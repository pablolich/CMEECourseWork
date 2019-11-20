#!/usr/bin/env python3

__appname__ = '[fitting.py]'
__author__ = 'Pablo Lechon (plechon@ucm.es)'
__version__ = '0.0.1'

## IMPORTS ##

import sys
import pandas as pd
import scipy as sc
from numpy import exp
import matplotlib.pylab as plt
from lmfit import Model
from scipy.optimize import least_squares
from numpy import exp

## CONSTANTS ##


## FUNCTIONS ##

def load_data():
    #load data
    dat = pd.read_csv('../Data/growth_data.csv')
    dat['y_t'] = sc.log(dat['PopBio'])
    #Get rid of complex parts
    dat['y_t'] = [sc.real(i) for i in dat.y_t]
    #select data of lactovacioulus planetarium_20
    dat_plot = dat[(dat.Species == 'Lactobaciulus plantarum') &
                   (dat.Temp  == 25) &
                   (dat.Medium == 'MRS')]
    #Sort by time, so the plot looks nice
    dat_plot = dat_plot.sort_values(by=['Time'])
    return (dat, dat_plot)

def cuadratic(t, a, b, c):
    return(a + b*t + c*t**2)

def cubic(t, a, b, c, d):
    #Not fitted because it gives the same result.
    return(a + b*t + c*t**2 + d*t**3)

def logistic_equation(t, N_0 = 1, r = 1, K = 1):
    return (N_0 * K * exp(r * t))/(K + N_0 * (exp(r * t)-1))

def gompertz(t, A, r, lam):
    return (A*(exp(-exp(r * exp(1) * (lam-t) / A + 1))))

#def baranyi(t, N_0, r, h0, N_max):
#    #Calculate At
#    #Change variables
#    A = 1/r * sc.log( exp(-r*t) + exp(-h0) - exp(-r*t - h0))
#    return( exp(N_0 + r*t + A -sc.log(  1 + ( exp(r*t + A) - 1 ) / \
#            ( exp(sc.log(N_max/N_0) ) )  ) ) )
#
def baranyi_nonexp(t, y_0, r, h0, y_max):
    #calculate at
    return( y_0 + r*t + 1/r * sc.log( exp(-r*t) + exp(-h0) - \
            exp(-r*t - h0)) - sc.log(  1 + ( exp(r*t + 1/r * sc.log( exp(-r*t)\
            + exp(-h0) - exp(-r*t - h0))) - 1 ) / \
            (exp(y_max - y_0) )) ) 

def buchanan(t, N_min, r, t_lag, t_max):
    #N_max = N_min + r * (t_max - t_lag)
    return(N_min + r * t * ((t >= t_lag) & (t <= t_max)) - r * t_lag * \
           (t > t_lag) + r * t_max * (t > t_max))

def gompertz_samraat(t, r_max, N_max, N_0, t_lag): 
    return(N_0 + (N_max - N_0) * exp(-exp(r_max * exp(1) * (t_lag - t)\
           /((N_max - N_0) * sc.log(10)) + 1)))


def main(argv):
    '''Main function'''
    dat, dat_plot = load_data()    

    #Create Models
    model_cuadratic = Model(cuadratic)
    model_cubic = Model(cubic)
    model_logistic = Model(logistic_equation) 
    model_gompertz = Model(gompertz)
    #model_gompertz_samraat = Model(gompertz_samraat)
    model_baranyi_nonexp = Model(baranyi_nonexp)
    model_buchanan = Model(buchanan)

    #Get results
    result_cuadratic = model_cuadratic.fit(dat_plot.PopBio, t = dat_plot.Time,
                                         a = 1, b = 1, c = 1)

    result_logistic = model_logistic.fit(dat_plot.PopBio, t = dat_plot.Time,
                                         N_0 = 1, r = 1, K = 1)


    #Initial parameters for gompertz
    A_init = max(dat_plot.PopBio)/min(dat_plot.PopBio)
    r_init = 100
    lam_init = 20
    result_gompertz = model_gompertz.fit(dat_plot.PopBio, t = dat_plot.Time,
                                         A = A_init ,  
                                         r = r_init, lam = lam_init)

    #result_gompertz_samraat = model_gompertz_samraat.fit(dat_plot.PopBio,
    #                                            t = dat_plot.Time, 
    #                                            N_max = max(dat_plot.PopBio),
    #                                            N_0 = min(dat_plot.PopBio),
    #                                            A = A_init, 
    #                                            r_max = r_init, 
    #                                            t_lag = lam_init)
    #
    
    #Initial parameters for baranyi
    r_init = 0.5
    h0_init = 0.1
    y_0_init = 2
    y_max_init = 9
    
    result_baranyi_nonexp = model_baranyi_nonexp.fit(dat_plot.y_t, 
                                       t = dat_plot.Time,
                                       y_0 = y_0_init, r = r_init, 
                                       h0 = h0_init, y_max = y_max_init)

    #Initial parameters for buchanan
    N_min_init = min(dat_plot.PopBio)
    r_init = 100
    t_lag_init = 15
    t_max_init = 35
    result_buchanan = model_buchanan.fit(dat_plot.PopBio, t = dat_plot.Time, 
                                    N_min = N_min_init, r = r_init, 
                                    t_lag = t_lag_init, t_max = t_max_init)
                               
    #Plot scatter and fit
    plt.scatter(dat_plot.Time, dat_plot.PopBio, s = 20)
    plt.plot(dat_plot.Time, result_cuadratic.best_fit, 'm-', 
             label = 'Cuadratic')
    plt.plot(dat_plot.Time, result_logistic.best_fit, 'r-', label = 'Logistic')
    plt.plot(dat_plot.Time, result_gompertz.best_fit, 'b-', label = 'Gompertz')
    plt.plot(dat_plot.Time, exp(result_baranyi_nonexp.best_fit), 'y-', 
             label = 'Baranyi')
    #plt.plot(dat_plot.Time, result_gompertz_samraat.best_fit, 'c-', 
    #         label = 'Gompertz Samraat')
    plt.plot(dat_plot.Time, result_buchanan.best_fit, 'k--',
             label = 'Buchanan')
    plt.legend()
    plt.show()

    return 0 

## CODE ##

if (__name__ == '__main__'):
    status = main(sys.argv)
    sys.exit(status)
     



