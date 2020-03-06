#!/usr/bin/env python3



__appname__ = '[fit_store_model_1.py]'
__author__ = 'Pablo Lechon (plechon@ucm.es)'
__version__ = '0.0.1'



## IMPORTS ##


import sys
import pandas as pd
import numpy as np
from models import quadratic, cubic, linear, logistic, gompertz, baranyi,\
                   buchanan
from progressbar import ProgressBar 
from lmfit import Minimizer, Parameters



## FUNCTIONS ##


def group_median(x, jump):
    '''
    Given a vector x, subdivided in groups of length jump, this function 
    calculates the  median of each group


    Parameters:

        x (ndarray): population vector
        jump (int): length of subgroup division of x


    Returns:

        group_median_vec (ndarray): Vector with medians of each group

    ''' 

    #If len(x) is multiple of jump then mult = 0 (False). Otherwise mult = 1 
    #(True)
    mult = bool(len(x)%jump)
    #Initialize result vector
    #Note the use of mult: if mult = 1, an extra 0 will be added for the
    #remainder group
    group_median_vec = np.zeros(int(len(x)/jump) + mult) 
    for i in range(0, len(x), jump):
        group_median_vec[int(i/jump)] = np.median(x[i:i+jump])

    return(group_median_vec)



def init_vals(t, pop, tol = 0.3):
    '''
    Detects and isolates the growing phase of the curve to fit a line to 
    that subset of data


    Parameters:

        t (list): time vector
        pop (list): population vector
        tol (float): threshold to determine limits of growth phase


    Returns:

        p (ndarray): parameters of the linear fit to growth phase data
        pop_t (ndarray): growth phase population vector
        line_t (ndarray): growth phase time vector
        
    '''

    #DETECT AND ISOLATE GROWING PHASE#
    ##################################
    #Transform input to arrays
    pop = np.array(pop)
    t = np.array(t)

    #For data groups with less than 50 points, calculate increment between
    #consecutive points
    if len(t)<50:
        grad = (pop[1:]-pop[0:-1])/(t[1:]-t[0:-1])
        #Select maximum increment
        grad_max = max(grad)
        #Mask vector grad to select only those values greater than a fraction
        #of grad_max determined by tol
        mask = grad>(tol*grad_max)
        #Find first True value after masking
        ind = np.nonzero(mask)[0][0]
        #Add one True at that position to recover the value that we lost when 
        #making the comparison
        mask = np.insert(mask, ind, True) 

    #For datasets with more than 50 points we group the points by groups of 
    #'jump' elements and calculate the median to eliminate short frequency
    #variations. The pervius procedure is applied once the smoothing has been
    #completed
    else:
        #Perform smoothing of data
        #Set jump
        jump = int(len(t)/10)
        #Calculate group median for both pop and t vectors
        group_median_pop = group_median(pop, jump)
        group_median_t = group_median(t, jump)
        #Calculate gradient of the smoothed  vectors
        grad = (group_median_pop[1:] - group_median_pop[0:-1])/ \
                (group_median_t[1:] - group_median_t[0:-1] )
        #Proceed as for len(t)<50 using the smoothed vectors
        grad_max = max(grad)
        mask = np.repeat(grad>(tol*grad_max), jump)
        ind = np.nonzero(mask)[0][0]
        mask = np.insert(mask, ind, (len(pop)-len(mask))*[True]) 

    #Isolate growing phase
    line_pop = pop[mask]
    line_t = t[mask]


    #FIT A STRAIGHT LINE TO THE GROWING PHASE#
    ##########################################
    try:
        p = np.polyfit(line_t,line_pop, 1)
    except:
        p = None

    return(p, line_pop, line_t) 



def init_vals_all_mod(pop, t):
    '''
    Determine optimal initial values for parameters corresponding to the
    linear models, and for those corresponding to the non-linear ones

    
    Parameters:
        
        pop (ndarray): population vector
        t (ndarray): time vector


    Returns:
        
        init_vals_ (list): initial values for all models

    '''

    #Linear models
    a_init = b_init = c_init = d_init = 1
    #Non-linear models
    #Asymptotes
    y_0_init = min(pop)
    y_max_init = max(pop)
    #Lag time and maximum growth rate
    p, line_pop, line_t = init_vals(t, pop)
    mu_max_init = p[0]*np.log(10)
    #find time_lag as intersection with y = N_0, not 0
    lam_init = (y_0_init-p[1])/p[0]
    #Set lam_init to a small arbitrary value in case of it being negative 
    #to avoid numerical problems in the fit
    if lam_init<0:
        lam_init = 1e-2

    #Create a DataFrame with initial values
    init_vals_ = [a_init, b_init, c_init, d_init, y_0_init, y_max_init, 
                  mu_max_init, lam_init]

    return(init_vals_)



def goodness(population, residual, par_name): 
    '''
    Calculates r_square, aic, bic


    Parameters:

        population (ndarray): population vector
        residual (list): residuals from fit
        params (list): parameter names


    Returns: 

        r_square (float): R square
        aic (float): Akaike Infromation Criteria
        bic (float): Bayesian Information Criteria

    '''

    #transform residuals back into linear space
    #r = 10**(np.abs(residual))
    r = residual
    #Get number of data points and of parameters
    ndata = len(population)
    nparams = len(par_name)
    #Mean of data
    y_mean = np.mean(population)
    #Calculate parameters
    rss = (r*r).sum()
    r_square = 1-rss/sum((population-y_mean)**2)
    aic = ndata + 2 +  ndata*np.log(2*np.pi/ndata) + ndata*np.log(rss) + \
          2*nparams
    bic = ndata*np.log(rss/ndata) + np.log(ndata)*nparams
    
    return(r_square, aic, bic)



def initialize_output():
    '''
    Initialite output

    Parameters:
        
        None


    Returns:

        dict_results (dict): holds data features (Species, Temp, Id...), model 
                             and fitted parameters and goodness of fit
                             parameters
        dict_evals (dict): holds fit evaluations, information for plotting 
                           title, legend, axis..., and information for plotting 
                           success_report

    '''


    #fit_results#
    #############
    #Initialize vector of models
    names_out = list(np.tile(model_names, ngroups))
    nres = ngroups*nmodels #length of dataframe
    #fill a dictionary  with initial data
    dict_results = {#Characteristics of data 
                    'Species':[0]*nres, 'Temp':[0]*nres,  'Medium':[0]*nres, 
                    'unique_id':[0]*nres, 'PopBio_units':[0]*nres,
                    #Model and fitted parameters
                    'model':names_out, 'a':[0]*nres, 'b':[0]*nres, 
                    'c':[0]*nres, 'd':[0]*nres, 'y_0':[0]*nres, 
                    'y_max':[0]*nres, 'mu_max':[0]*nres, 'lam':[0]*nres,
                    #Fit results and goodness parameters
                    'residuals':[0]*nres, 'fit_success': [0]*nres,
                    'r_square':[0]*nres, 'aic':[0]*nres, 'bic':[0]*nres, 
                    'best':[0]*nres, 'w_i':[0]*nres}


    #fit_evals#
    ###########
    #Initialize vector of models
    names_out = list(np.tile(np.repeat(model_names, nevals), ngroups))
    leneval = ngroups*nevals*nmodels #length of dataframe
    #fill a dictionary with initial data
    dict_evals = {#Fit evaluations
                  't':[0]*leneval, 'fit_eval':[0]*leneval, 
                  #Information for ploting title, legend, axis... 
                  'model':names_out, 'Species':[0]*leneval, 
                  'Temp':[0]*leneval, 'Medium':[0]*leneval,
                  'unique_id':[0]*leneval,'best':[0]*leneval, 
                  #Information for plotting the success_report
                  'fit_success':[0]*leneval}

    return(dict_results, dict_evals)


def fit_mod(t, t_eval, pop, model, par_name, par_vals, i, k_model):
    '''
    Fit data to a model


    Parameters:

        t (ndarray): time vector
        pop (ndarray): population vector 
        t_eval (ndarray): time vector for which the fit will be evaluated
        model (function): model to be fitted
        par_name (list): parameter names
        par_vals (list): parameter values
        i (int): data group number
        k_model (int): current model to fit
        

    Returns:

        None

    '''


    #FIT MODEL#
    ###########
    #Initialize parameters of the model 
    params = Parameters()
    for p in range(len(par_name)):
        min_ = -np.inf
        #Set a lower bound for t_lag and mu_max
        if par_name[p] == 'lam' or par_name[p] == 'mu_max':
            min_ = 0
        params.add(par_name[p], value = par_vals[p], min = min_)
    #Fit
    minner = Minimizer(model, params, fcn_args = (t, pop))
    fit_ = minner.minimize()


    #EXTRACT INFORMATION FROM FIT#
    ##############################
    #Success/fail
    suc = int(fit_.success)

    #Paramteters and residuals 
    fit_par = [fit_.params.valuesdict()[k] for k in tuple(par_name)]
    residual = fit_.residual

    #Calculating r_square, aic, bic 
    r_square, aic, bic = goodness(pop, residual, par_name)
    nm = model.__name__
    if (nm == 'gompertz' or
           nm == 'baranyi' or
           nm == 'buchanan'):
        y_0 = min(pop) #Sometimes the fitted y_0 is too low
        y_max = fit_.params.valuesdict()['y_max']
        #Get rid of points outside the growing phase (in the asymptotes)
        #y_0 region
        #Throw away points outside the desired interval
        tol = 0.1
        ran = y_max-y_0
        #To avoid eliminating data that spans a small range
        if ran < 1:
            tol = ran*tol
        ints = [-np.inf, y_0 + tol*abs(y_0), y_max - tol*abs(y_max), np.inf]
        pop_array = np.array(pop)
        mask = (pop_array>ints[0]) & (pop_array<ints[1]) |\
               (pop_array>ints[2]) & (pop_array<ints[3])
        g_phase = pop_array[np.invert(mask)]
        #If r_max is not properly constrained (<2 points in the growing phase
        #or nparams = ndata (r_square = 1),the fit is flagged with a warning 
        #(-1)
        if (len(g_phase) <= 1) | (r_square == 1):
            suc = -1

    #The logistic model is treated differently because it has a different shape
    #in the log space.
    if (nm == 'logistic'):
        y_max = max(pop)
        #Get rid of points outside the growing phase (in the asymptotes)
        #y_0 region
        #Throw away points outside the desired interval
        tol = 0.1
        ints = [y_max - tol*abs(y_max), np.inf]
        pop_array = np.array(pop)
        mask = (pop_array>ints[0]) & (pop_array<ints[1])
        g_phase = pop_array[np.invert(mask)]
        #If r_max is not properly constrained (<2 points in the growing phase
        #or nparams = ndata (r_square = 1),the fit is flagged with a warning 
        #(-1)
        if (len(g_phase) <= 1) | (r_square == 1):
            suc = -1

    #EVALUATING MODEL#
    ##################
    #Creating synthetic data to evaluate fitted model at t_eval times
    synth_pop = np.ones(len(t_eval))
    synth_res = model(fit_.params, t_eval, synth_pop)
    #Since the function provides the residual, we have to add our synthetic
    #data to recover the predicted values
    evaluation = list(synth_res + synth_pop)
    

    #STORING#
    #########
    #Store fitted parametes, residual, success of fit and goodness of fit
    #parameters

    #fit_results
    store_names = par_name + ['residuals','fit_success', 
                              'r_square', 'aic', 'bic']
    store_values = (#Fitted parameters
                    fit_par +
                    #Residual and succes of fit
                    [list(residual), suc] + 
                    #Goodness of fit
                    [r_square, aic, bic])
    #Assign values to keys (names) in dictionary subset
    for j in range(len(store_values)):
        dict_results[store_names[j]][i * nmodels + k_model] = store_values[j]

    #fit_evals
    success = np.repeat(store_values[store_names.index('fit_success')], nevals)
    store_names = ['fit_eval', 'fit_success']
    store_values = ([evaluation]+[success])
    for j in range(len(store_values)):
        dict_evals[store_names[j]][nevals*(i*nmodels+k_model):nevals*\
                   (i*nmodels+k_model)+nevals] = store_values[j]

    return()



def fill_output(fit_data, t_eval, i, k_model):
    '''
    Fills output with known information

    Parameters:     
        
        fit_data (pandas.DataFrame): data group being fitted
        t_eval (ndarray): time vector for which the fit will be evaluated
        i (int): current data groups index 
        k_model (int): model index

    Return:

        None
 
    '''


    #FILL OUTPUT FOR CURRENT DATA GROUP#
    ####################################

    #fit_results 
    #Getting i-th values for Species, Temperature, Medium and unique_id
    known_values = list(fit_data.columns[2:]) #Avoid selecting Time and y_t
    rows = np.array(fit_data.loc[0, known_values])
    #Assign known values to their correct spots in the fit_results
    for j in range(len(known_values)):
        dict_results[known_values[j]][i * nmodels + k_model] = rows[j]
    #fit_results.loc[i * nmodels + k_model, known_values] = rows

    #fit_evals 
    #Repeat to fill nmodels
    t_eval_rep = np.tile(t_eval, nmodels)
    ntot = nevals*nmodels #Total number of rows per data group
    #Assign the ith (current data group) set of rows of fit_evals
    dict_evals['t'][i*ntot:(i+1)*ntot] = t_eval_rep
    #Assign repeatedly to fit_evals to fill all evaluations
    #Species, Temp, Medium, PopBio_units vectors
    tot = np.array([np.repeat(np.array(fit_data.Species)[0], ntot ),
                    np.repeat(np.array(fit_data.Temp)[0], ntot),
                    np.repeat(np.array(fit_data.Medium)[0], ntot),
                    np.repeat(np.array(fit_data.unique_id)[0], ntot)])
    #-1 because we don't want popunits in fits_evals dataframe
    for j in range(len(known_values)-1):
        dict_evals[known_values[j]][i*ntot:(i+1)*ntot] = tot[j]
    return()

def best_model(i, k_model, nevals, nmodels, model_names):
    '''Rank models based on AIC and calculate akaike weights'''


    #Ranking#
    #########
    ntot = nevals*nmodels
    #Vector of aic corresponding to the current curve for the models that spit
    #out mu_max
    aic_vec = dict_results['aic'][i*nmodels:i * nmodels + k_model-1]
    aic_vec_w = aic_vec[4:7]
    min_aic = min(aic_vec_w)
    #Get AIC differences
    delta = np.array(aic_vec_w) - min_aic
    #Calculate likelihood of model given the data
    L = np.exp(-0.5*delta)
    #Calculate model probabilties
    w_i = list(L/(sum(L)))
    #Vector with the index of the AIC that would sort that vector increasingly
    v = list(np.argsort(aic_vec))
    #Rank elements by applying argsort once more
    rank = np.argsort(v)
    best = np.array([0]*len(v))
    best[v[0]] = 1
    dict_results['best'][i*nmodels:i * nmodels + k_model-1] = best
    dict_results['w_i'][i*nmodels+4:i * nmodels + k_model-1] = w_i
    tot = list(np.repeat(rank, nevals))
    dict_evals['best'][i*ntot:(i+1)*ntot] = tot

    #Akaike weights#
    ################
    #Calculate AIC differences with respect to the best model (lowest AIC)
    
    return()


def main(argv):
    '''Main function'''
    

    ###########
    #LOAD DATA#
    ###########
    data = pd.read_csv('../Data/LogisticGrowthData_mod.csv')


    #########################
    #PREALOCATE FINAL OUTPUT#
    #########################
    #Create a list with models to fit
    models = [#Linear models
              linear, quadratic, cubic, 
              #Rest of non-linear models
              logistic, gompertz, buchanan, baranyi]
    #Get model names from the functions
    global model_names; model_names = [i.__name__ for i in models]
    #Each data group with constant conditions (Species-Temp-Medium) gets one id 
    group_id = np.unique(data.unique_id)
    #Initialize dimensions of output data
    global ngroups; ngroups = len(group_id)
    global nmodels; nmodels = len(models)
    global nevals; nevals = 100
    #Initialize output data
    #global fit_results
    #global fit_evals
    global dict_results
    global dict_evals
    dict_results, dict_evals = initialize_output()


    #########################################################
    #PERFORM NLLS FITTING TO EACH MODEL  FOR EACH DATA GROUP#
    #########################################################


    #LOOP THROUGH EACH DATA GROUP#
    ##############################
    pbar = ProgressBar() # Implement progress bar
    for i in pbar(range(ngroups)):


        #GET DATA GROUP TO FIT#
        #######################
        #Resetting index to 0, 1, 2, ... to be able to select the first row
        #when prealocating output with known values (16 lines below)
        fit_data = data[data.unique_id == group_id[i]].reset_index(drop = True)
        #Get x (time) and y (pop) vectors
        t = np.array(fit_data.Time)
        pop = np.array(fit_data.y_t)

        #CALCULATES STARTING VALUES FOR ALL MODEL PARAMETERS#
        #####################################################
        all_init_vals = init_vals_all_mod(pop, t)


        #####################################
        #PERFORM NLLS FITTING FOR EACH MODEL#
        #####################################
        #time vector to evaluate fits
        t_eval = np.linspace(start = min(t), stop = max(t), num = nevals)

        #PREPARE ITERATIVE FITTING OF MODELS# 
        #####################################
        #Assign parameters names and create 2 parameter objects; one for the 
        #linear models and one for non-linear models.
        all_comb = {'linear':    [['y_0', 'mu_max'],
                                       [all_init_vals[4],all_init_vals[6]]],
                    'quadratic':      [['a', 'b', 'c'],
                                       [all_init_vals[i] for i in range(3)]],
                    'cubic':          [['a', 'b', 'c', 'd'],
                                       [all_init_vals[i] for i in range(4)]], 
                    'logistic':       [['y_0', 'y_max', 'mu_max'],
                                       [all_init_vals[i] for i in range(4,7)]],
                    'gompertz':       [['y_0', 'y_max', 'mu_max', 'lam'], 
                                       [all_init_vals[i] for i in range(4,8)]],
                    'buchanan':       [['y_0', 'y_max', 'mu_max', 'lam'], 
                                       [all_init_vals[i] for i in range(4,8)]], 
                    'baranyi':        [['y_0', 'y_max', 'mu_max', 'lam'], 
                                       [all_init_vals[i] for i in range(4,8)]]}

                  

        #LOOP THROUGH MODELS AND FIT THEM#
        ##################################
        k_model = 0
        while k_model <= len(models):
            try:
                #Fill fit_results and fit_evals with data we know prior to the 
                #fitting
                fill_output(fit_data, t_eval, i, k_model)
                #Fit k_model to data
                fit_mod(t = t,
                        t_eval = t_eval,
                        pop = pop, 
                        model = models[k_model],
                        par_name = all_comb[model_names[k_model]][0], 
                        par_vals = all_comb[model_names[k_model]][1],
                        i = i, 
                        k_model = k_model)
                k_model += 1
            #Determine best model for that data
            except: 
                k_model += 1
                pass
        #store the indices that would sort the array of aic for each model
        best_model(i, k_model, nevals, nmodels, model_names)
    #Save for analysis and plotting in R...
    fit_results_df = pd.DataFrame(dict_results)
    fit_evals_df = pd.DataFrame(dict_evals)
    #Flag best fit for each data group
    #Get the vector of bests fits
    best = fit_results_df['best']
    #Get indices of best fit for each data set
    ind = np.where(best == 1)[0]
    fit_results_df.loc[ind, 'fit_success'] = -2
    fit_evals_df.to_csv('../Results/fit_evals.csv')
    fit_results_df.to_csv('../Results/fit_results.csv')
    return 0



## CODE ##

if (__name__ == '__main__'):
    status = main(sys.argv)
    sys.exit(status)
