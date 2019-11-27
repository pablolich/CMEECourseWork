# CMEE 2019 HPC excercises R code main proforma
# you don't HAVE to use this but it will be very helpful.  If you opt to write everything yourself from scratch please ensure you use EXACTLY the same function and parameter names and beware that you may loose marks if it doesn't work properly because of not using the proforma.

name <- "Pablo Lechon"
preferred_name <- "Pablo"
email <- "plechon@ucm.es"
username <- "pl1619"
# will be assigned to each person individually in class and should be between 0.002 and 0.007
personal_speciation_rate <- 0.002

# Question 1
species_richness <- function(community){
  return(length(unique(community)))
}

# Question 2
init_community_max <- function(size){
  #return a sorted sequence with the specified size
  return(seq(size))
}

# Question 3
init_community_min <- function(size){
  #return a vector of ones of the specified size
  return(rep(1,size))
}

# Question 4
choose_two <- function(max_value){
  #Chooses two values from a specified community through the max_value
  return(sample(init_community_max(max_value), 2, replace = F))
}

# Question 5
neutral_step <- function(community){
  #Substitutes one value from the community with another value
  ind = choose_two(length(community))
  return(replace(x = community, list = ind[1], values = community[ind[2]]))
}

# Question 6
neutral_generation <- function(community){
  #Simulates several neutral_steps on a community so that a generation has passed.
  switch = 0
  if (length(community)%%2 == 1){
    #If the number is odd, set switch to 0.5 or -0.5 to summ it to the result
    switch = sample(c(0.5,-0.5),1)
  }
  for (i in seq(length(community)/2 + switch)){
    community = neutral_step(community)
  }
  return(community)
}

# Question 7
neutral_time_series <- function(community,duration){
  #Performs a neutral theory simulation and return a time series of species richness in the system.
  
  #to account for the initial community richness:
  richness = c(length(unique(community)),rep(NA, duration))
  for (i in seq(2,duration + 1)){
    community = neutral_generation(community)
    richness[i] = length(unique(community))
  }
  return(richness)
}


# Question 8
question_8 <- function() {
  size = 100
  generations = 200
  # clear any existing graphs and plot your graph within the R window
  graphics.off()
  time_series = neutral_time_series(community = init_community_max(size), duration = generations)
  plot(seq(1,generations+1), time_series, pch = 19, cex = 0.5)
  return(cat('
  In this graph we can see how the richness decreases with generations. This reflects very 
  well the Volter model we saw in class, ilustrated with the voting systems. The richness decreases because 
  when after every generation some species go extinct, and others reproduce to occupy their positions.  
  This favors the species who reproduces more, until the system converges to a stable state in which  
  only one species remains.
             '))
}

# Question 9
neutral_step_speciation <- function(community,speciation_rate){
#Performs a step of neutral model with speciation
  
max_com = max(community)
ind = choose_two(length(community))

#Determine wether we substitute with offspring from an existing species, or with a new species.
speciation = sample(c(1,0), size = 1, prob = c(speciation_rate, 1-speciation_rate))
if (speciation){
  #create new species and replace it
  max_com = max_com + 1
  return(replace(x = community, list = ind[1], values = max_com))
}
else{
  #replace with offspring
  return(replace(x = community, list = ind[1], values = community[ind[2]]))
}
}


# Question 10
neutral_generation_speciation <- function(community,speciation_rate){
  #Simulates several neutral_steps on a community so that a generation has passed with speciation rate
  #non-zero.
  switch = 0
  if (length(community)%%2 == 1){
    #If the number is odd, set switch to 0.5 or -0.5 to summ it to the result
    switch = sample(c(0.5,-0.5),1)
  }
  for (i in seq(length(community)/2 + switch)){
    community = neutral_step_speciation(community, speciation_rate)
  }
  return(community)
}

# Question 11
neutral_time_series_speciation <- function(community,speciation_rate,duration)  {
  #Performs a neutral theory simulation and return a time series of species richness in the system
  #with speciation rate non-zero.
  
  #to account for the initial community richness:
  richness = c(length(unique(community)),rep(NA, duration))
  for (i in seq(2,duration + 1)){
    community = neutral_generation_speciation(community, speciation_rate)
    richness[i] = length(unique(community))
  }
  return(richness)
}

# Question 12
question_12 <- function() {
  size = 100
  generations = 200
  speciation_rate = 0.1
  # clear any existing graphs and plot your graph within the R window
  graphics.off()
  
  time_series_max = neutral_time_series_speciation(community = init_community_max(size), 
                                                   duration = generations,
                                                   speciation_rate = speciation_rate)
  time_series_min = neutral_time_series_speciation(community = init_community_min(size), 
                                                   duration = generations,
                                                   speciation_rate = speciation_rate)
  
  plot(seq(1,generations+1), time_series_max, pch = 19, cex = 0.5, col = 'blue')
  points(seq(1,generations+1), time_series_min, pch = 19, cex = 0.5, col = 'green')
  return(cat('
  In this graph we can see how the richness evolves with generations for two initial conditions
  In the first one, we have the maximum richness. This reflects very well the Volter model we saw in class,
  ilustrated with the voting systems. The richness decreases because when after every generation some 
  species go extinct, and others reproduce to occupy their positions. However, since there is a weak 
  speciation, the satble state is not a static equilibrium, but a dynamic equilibrium state where the 
  richness oscilates around a non-one average value. It is expected that if we increase the speciation 
  rate, the average value will increase. As for the second initial condition, minimum richness, the system
  also converges to the dynamic stable state described above.
             '))
  
  return("type your written answer here")
}

# Question 13
species_abundance <- function(community){
  #Calculate the abundance of species in a community
  return(sort(as.numeric(table(community)), decreasing = T))
}

# Question 14
octaves <- function(abundance_vector){
  return(tabulate(floor(log2(abundance_vector))+1))
}
# Question 15
sum_vect <- function(x, y) {
  dif = length(x)-length(y)
  if (dif<0){#y is longer than x
    x = c(x, rep(0, abs(dif)))
  }
  else{
    y = c(y, rep(0, dif))
  }
  return(x+y)
}

# Question 16 
question_16 <- function()  {
  # clear any existing graphs and plot your graph within the R window
  graphics.off()
  init_gen = 200
  stable_state = 2000
  speciation_rate = 0.1
  record = 20
  community = init_community_min(100)
  octaves_ = 0
  for (i in seq(init_gen + stable_state)){
    community = neutral_generation_speciation(community, speciation_rate)
    if (i >= init_gen){
      if (i%%record == 0){
        #Cum sum octaves
        octaves_ = sum_vect(octaves_, octaves(species_abundance(community)))
      }
    }
  }
  barplot(round(octaves_/(stable_state/record)))
  return(cat("
  It doesn't change from max to min, and we arrive to an equilibrium in which one species 
  dominate and the other ones are minoritary, but still exist
             "))
}

# Question 17
cluster_run <- function(speciation_rate, size, wall_time, interval_rich, interval_oct, burn_in_generations, output_file_name)  {
  community = init_community_min(size)
  richness = c()
  octaves_ = list()
  i = 1
  generation = 0 #To record the initial richness
  #divide by 60 to transform to minutes
  ptm <- proc.time()
  while (as.numeric((proc.time() - ptm)[3]) <= (wall_time*60)){
    #When generation reaches an interval_rich multiple, calculate richness and store it.
    if ((generation %% interval_rich == 0) & (generation <= burn_in_generations)){
      richness = c(richness, length(unique(community)))
    }
    if (generation %% interval_oct == 0){
      octaves_ = c(octaves_, list(octaves(species_abundance(community))))
    }
    community = neutral_generation_speciation(community, speciation_rate)
    generation = generation + 1
  }
  #Convert output to lists
  tot_time = proc.time() - ptm
  richness = list(richness)
  community = list(community)
  args = list(speciation_rate, size, wall_time, interval_rich, interval_oct, burn_in_generations)
  #Save lists to a rda file
  save( tot_time, richness, community, args, octaves_, file =  output_file_name)
  return(0)
}


# Questions 18 and 19 involve writing code elsewhere to run your simulations on the cluster

# Question 20 
process_cluster_results <- function()  {
  # clear any existing graphs and plot your graph within the R window
  list_files = list.files('.', pattern = 'result_')
  octaves_500 = rep(0,1); octaves_1000 = rep(0,1); octaves_2500 = rep(0,1); octaves_5000 = rep(0,1)
  #Counters for each size
  count_500 = 0; count_1000 = 0; count_2500 = 0; count_5000 = 0
  for (i in list_files){
    load(i) 
    #Get rid of the burn period
    burn = args[[6]]
    octaves_del = octaves_[-seq(burn)]
    #Add the elements in the current octave set to the running total per size
    if (length(community[[1]]) == 500){
      for (j in seq(length(octaves_del))){
        octaves_500 = sum_vect(octaves_500, octaves_del[[j]])
        count_500 = count_500 + 1
      }
    }
    else if (length(community[[1]]) == 1000){
      for (j in seq(length(octaves_del))){
        octaves_1000 = sum_vect(octaves_1000, octaves_del[[j]])
        count_1000 = count_1000 + 1
      }
    } 
    else if (length(community[[1]]) == 2500){
      for (j in seq(length(octaves_del))){
        octaves_2500 = sum_vect(octaves_2500, octaves_del[[j]])
        count_2500 = count_2500 + 1
      }
    } 
    else {
      for (j in seq(length(octaves_del))){
        octaves_5000 = sum_vect(octaves_5000, octaves_del[[j]])
        count_5000 = count_5000 + 1
      }
    }
    
    #Average octaves
    av_octave_500 = octaves_500/count_500
    av_octave_1000 = octaves_1000/count_1000
    av_octave_2500 = octaves_2500/count_2500
    av_octave_5000 = octaves_5000/count_5000
    
    #Plot in a four panel graph
    mydata <- data.frame(Barplot1=av_octave_500, Barplot2=av_octave_1000,
                         Barplot3=av_octave_2500, Barplot4=av_octave_5000)
    print(mydata)
    barplot(as.matrix(mydata), main="Interesting", ylab="Total", beside=TRUE, 
            col=terrain.colors(5))
    legend(13, 12, c("Label1","Label2","Label3","Label4","Label5"), cex=0.6, 
           fill=terrain.colors(5))
  }
  combined_results = list(av_octave_500 , av_octave_1000 , av_octave_2500 , av_octave_5000)
  return(combined_results)
}

# Question 21
question_21 <- function()  {
  return("type your written answer here")
}

# Question 22
question_22 <- function()  {
  return("type your written answer here")
}

# Question 23
chaos_game <- function()  {
  # clear any existing graphs and plot your graph within the R window
  return("type your written answer here")
}

# Question 24
turtle <- function(start_position, direction, length)  {

  return() # you should return your endpoint here.
}

# Question 25
elbow <- function(start_position, direction, length)  {
  
}

# Question 26
spiral <- function(start_position, direction, length)  {
  return("type your written answer here")
}

# Question 27
draw_spiral <- function()  {
  # clear any existing graphs and plot your graph within the R window
  
}

# Question 28
tree <- function(start_position, direction, length)  {
  
}
draw_tree <- function()  {
  # clear any existing graphs and plot your graph within the R window
}

# Question 29
fern <- function(start_position, direction, length)  {
  
}
draw_fern <- function()  {
  # clear any existing graphs and plot your graph within the R window
}

# Question 30
fern2 <- function(start_position, direction, length)  {
  
}
draw_fern2 <- function()  {
  # clear any existing graphs and plot your graph within the R window
}

# Challenge questions - these are optional, substantially harder, and a maximum of 16% is available for doing them.  

# Challenge question A
Challenge_A <- function() {
  # clear any existing graphs and plot your graph within the R window
}

# Challenge question B
Challenge_B <- function() {
  # clear any existing graphs and plot your graph within the R window
}

# Challenge question C
Challenge_C <- function() {
  # clear any existing graphs and plot your graph within the R window
}

# Challenge question D
Challenge_D <- function() {
  # clear any existing graphs and plot your graph within the R window
  return("type your written answer here")
}

# Challenge question E
Challenge_E <- function() {
  # clear any existing graphs and plot your graph within the R window
  return("type your written answer here")
}

# Challenge question F
Challenge_F <- function() {
  # clear any existing graphs and plot your graph within the R window
  return("type your written answer here")
}

# Challenge question G should be written in a separate file that has no dependencies on any functions here.


