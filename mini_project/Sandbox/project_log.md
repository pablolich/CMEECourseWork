
# Questions

	Difference between exp and nonexp?

    Mon Feb  3 23:56:53 GMT 2020
    	
    	Where can I find a modified gompertz model paper?

    
    Tue Feb  4 17:08:40 GMT 2020
    	
    	Is the treatement of Tetraselmis tetrahele correct? (Averaging over time and repetitions)

    Thu Feb  6 23:13:36 GMT 2020
    	
    	Why can I fit my logged data with the same model I fit my linear data in the logistic model? How can I see what is the new meaning of my parameters? Show him jmy calculations to see that it is actually that. If correct, I should apply this transformation in the parameters to only those models which are thought to be fitted in linear space: a.k.a. Logistic, gompertz, buchannan, exponential. The only ones that have been built in log space are baranyi and exponential lag. 


    Fri Feb  7 16:35:21 GMT 2020

    	When I log data, some of it is of the form 0.6..., which gives me negative logarithm values. To calculate mu_max from there is a pain
# Things to do 

## Priority 1
	1. Get rid of fits with unconstrained parameters.
	2. Get rid of really bad models: using R^2?
	2. Different type of success (all 0's?, unconstrained parameters?)
        3. Fit TPC and normal curves.	
	1. Write mathematical introduction to the models.
	2. Modularize code. Organize flow and move functions together if they are similar etc.


