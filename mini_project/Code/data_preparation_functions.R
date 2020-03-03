binning = function(x, precision){
  #Initialize output
  means = c()
  sets = list()
  ind_sets = list()#Holds the indices in t of elements in sets
  for (i in seq(length(x))){
    #If sets and means are empty, initialize with the first element of x
    if (length(sets) == 0 && length(means) == 0){
      means[i] = x[i]
      sets[[i]] = x[i]
      ind_sets[[i]] = i
    }
    else{
      #Loop through means to check if x[i] belongs to one of them
      #Initialize a vector of FALSE. After looping through the means, the vector
      #will have TRUE values for those mean values that span a confidence interval
      #that includes x[i]
      bool_ = rep(F, length(means))
      for (j in seq(length(means))){
        #Check if x[i] is within a threshold interval of means[j]
        if ((x[i]>((1-precision)*means[j]) && x[i]<((1+precision)*means[j]))){
          bool_[j] = T
        }
      }
      #A group was found for the value x[i]
      if (any(bool_)){
        #Where does it belong to?
        ind = which(bool_ == T)[1]
        #Add it to the corresponding set of values in the sets vector
        sets[[ind]] = c(sets[[ind]], x[i])
        ind_sets[[ind]] = c(ind_sets[[ind]], i)
        #Update that value of the mean with the new added vector
        means[ind] = median(sets[[ind]])
      }
      #The element is not in any of the means vector elements
      else{
        #We add it as a new element to the means vector, and we create a new
        #element in the sets list
        means = c(means, x[i])
        #To add a new list, we use the new length of means
        sets[[length(means)]] = x[i]
        ind_sets[[length(means)]] = i
      }
    }
  }
  return(ind_sets)
}

best_model = function(d){
  #Determines the best model based on its AIC scores
  #Get score for al models for each id
  models = unique(d$model)
  #Preallocation
  score = rep(0,length(models))
  j = 1
  for (i in models){
    #Get data from the ith model
    d_mod = d[which(d$model == i),]
    #Calculate score
    score[j] = sum(d_mod[which(d_mod$best == 1),]$best)
    j = j + 1
  }
  #Select best model
  best_model = models[which(score == max(score))]
  return(best_model)
}