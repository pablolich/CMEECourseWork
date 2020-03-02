#!/usr/bin/env python3

__appname__ = '[fitting.py]'
__author__ = 'Pablo Lechon (plechon@ucm.es)'
__version__ = '0.0.1'

## IMPORTS ##

import sys
import scipy as sc

## CONSTANTS ##


## FUNCTIONS ##


## MODELS ##

def quadratic(params, t, data):
    a = params['a']
    b = params['b']
    c = params['c']
    model = a + b*t + c*t**2
    return(model - data)

def cubic(params, t, data):
    a = params['a']
    b = params['b']
    c = params['c']
    d = params['d']
    model = a + b*t + c*t**2 + d*t**3
    return(model - data)

def linear(params, t, data):
    mu_max = params['mu_max']
    y_0 = params['y_0']
    #Change base from e to 10
    model = y_0 + mu_max*t
    return(model-data)

def logistic(params, t, data):
    mu_max = params['mu_max'] 
    y_max = params['y_max']
    y_0 = params['y_0']
    model = sc.real(sc.log10(y_0*y_max/(y_0 + (y_max-y_0)*\
            sc.exp(-mu_max*t))))
    return(model - data) 

def gompertz(params, t, data):
    y_max = params['y_max']
    y_0 = params['y_0']
    mu_max = params['mu_max']
    lam = params['lam']
    model = y_0 + (y_max - y_0) * sc.exp(-sc.exp(mu_max * sc.exp(1) * \
            (lam - t)/((y_max - y_0) * sc.log(10)) + 1))
    return (model - data)


def buchanan(params, t, data):
    #t_max = (y_max-y_0)/mu_max + lam
    y_0 = params['y_0']
    mu_max = params['mu_max']
    lam = params['lam']
    y_max = params['y_max']
    model = (y_0 + (t >= lam) * (t <= (lam + (y_max - y_0) * sc.log(10)/ \
            mu_max)) * mu_max * (t - lam)/sc.log(10) + (t >= lam) * (t > \
            (lam + (y_max - y_0) * sc.log(10)/mu_max)) * (y_max - y_0))
    return(model - data)

def baranyi(params, t, data):
    mu_max = params['mu_max']
    lam = params['lam']
    y_max = params['y_max']
    y_0 = params['y_0']
    model = sc.real(y_max + sc.log10((-1+sc.exp(mu_max*lam) + \
            sc.exp(mu_max*t))/ (sc.exp(mu_max*t) - 1 + sc.exp(mu_max*lam) * \
            10**(y_max-y_0))))
    return(model - data)

#Secondary models

def lactin2(params, T, data):
    rho = params['rho']
    Tmax = params['Tmax']
    delta = params['delta']
    lam = params['lam']
    model = sc.exp(rho*T) - sc.exp(rho*Tmax - (Tmax-T)/delta)+lam
    return(model-data)

def ratkowsky(params, T, data):
    b = params['b']
    Tmin = params['Tmin']
    Tmax = params['Tmax']
    c = params['c']
    model = (b*(T-Tmin)*(1-sc.exp(c*(T-Tmax))))**2
    return(model-data)

def hinshelwood(params, T, data):
    R = 8.314
    k1 = params['k1']
    E1 = params['E1']
    k2 = params['k2']
    E2 = params['E2']
    model = k1*sc.exp(-E1/(R*T)) - k2*sc.exp(-E2/(R*T))
    return(model-data)
