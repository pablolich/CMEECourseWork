
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
	0. If, for one fit_evals, all evaluations are 0, declare that as fail.
	1. Get rid of the dyplyr package in plotting_1 and co.
	1. A model is only best if its AIC is 2/3 times lower than the competing ones.
	1. Copy the compile latex sh file so that the call is more elegant.
	1. Test wether my calculated AIC match the AIC of the computer, this would mean that my errors are normally distributet, in the case that they match. if not, scream and cry
	1. I need to talk about the growing curves in the introduction.
 	1. Where is that Rplots.pdf plot coming from?
	2. Change names of output files so that they are more meaningful.


