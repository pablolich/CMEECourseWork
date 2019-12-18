# CMEE 2019 HPC excercises R code main proforma
# you don't HAVE to use this but it will be very helpful.  If you opt to write everything yourself from scratch please ensure you use EXACTLY the same function and parameter names and beware that you may loose marks if it doesn't work properly because of not using the proforma.
library(ggplot2)
library(ggpubr)
library(ggrepel)
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
  richness = c(species_richness(community),rep(NA, duration))
  for (i in seq(2,duration + 1)){
    community = neutral_generation(community)
    richness[i] = species_richness(community)
  }
  return(richness)
}


# Question 8
question_8 <- function() {
  size = 100
  generations = 200
  # clear any existing graphs and plot your graph within the R window
  graphics.off()
  y = neutral_time_series(community = init_community_max(size), duration = generations)
  x = seq(generations + 1)
  df = data.frame(x, y)
  p = ggplot(df, aes(x, y)) + 
    geom_point(size = 1.5) + 
    theme_bw() + 
    theme(panel.grid.major = element_blank(), 
          panel.grid.minor = element_blank(),
          plot.title = element_text(hjust = 0.5, face = 'bold', size = 16),
          axis.text=element_text(size=12),
          axis.title=element_text(size=16)) + 
    labs(title = 'Time series of Neutral Model', x = 'Generations', y = 'Richness')
  print(p)
  
  return(cat('
  In this graph we can see how the richness decreases with generations because 
  after every generation some species go extinct, and others reproduce to occupy their positions.
  The species that reproduce have more chances to reproduce in the next generation, so the stable
  state of this system is that of one dominant species.
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
  richness = c(species_richness(community),rep(NA, duration))
  for (i in seq(2,duration + 1)){
    community = neutral_generation_speciation(community, speciation_rate)
    richness[i] = species_richness(community)
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
  x = seq(generations + 1)
  dfmin = data.frame(x, time_series = time_series_min, Initial.State = rep('Min', length(time_series_min)))
  dfmax = data.frame(x, time_series = time_series_max, Initial.State = rep('Max', length(time_series_max)))
  df = rbind(dfmin, dfmax)
  p = ggplot(df, aes(x, time_series, color = Initial.State)) + 
    geom_point(size = 0.7) + 
    geom_line(size = 0.2)+
    theme_bw() + 
    theme(panel.grid.major = element_blank(), 
          panel.grid.minor = element_blank(),
          plot.title = element_text(hjust = 0.5, face = 'bold', size = 16),
          axis.text=element_text(size=12),
          axis.title=element_text(size=16), 
          legend.position = c(0.2,0.8),
          legend.background = element_rect(linetype = 1, color = 'white', size = 0.2),
          ) + 
    labs(title = 'Time series of Neutral Model with speciation', x = 'Generations', y = 'Richness', 
         col = 'Initial Diversity') 
  print(p)
  
  return(cat('
  In this graph we can see how the richness evolves with generations for two initial conditions; maximum
  diversity (blue), and minimum diversity (red). Due to the existance ofa weak speciation, the satble state
  is not a static, but a dynamic equilibrium state where the richness oscilates of both initial states
  converges to a non-one average value. It is expected that if we increase the speciation rate, the 
  average value will increase.
             '))
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
  #Minimum diversity
  community = init_community_min(100)
  octaves_min = 0
  for (i in seq(init_gen + stable_state)){
    community = neutral_generation_speciation(community, speciation_rate)
    if (i >= init_gen){
      if (i%%record == 0){
        #Cum sum octaves
        octaves_min = sum_vect(octaves_min, octaves(species_abundance(community)))
      }
    }
  }
  #Maximum diversity
  community = init_community_max(100)
  octaves_max = 0
  for (i in seq(init_gen + stable_state)){
    community = neutral_generation_speciation(community, speciation_rate)
    if (i >= init_gen){
      if (i%%record == 0){
        #Cum sum octaves
        octaves_max = sum_vect(octaves_max, octaves(species_abundance(community)))
      }
    }
  }
  av_octaves_min = octaves_min/(stable_state/record)
  av_octaves_max = octaves_max/(stable_state/record)
  df_min = data.frame(x = seq(length(av_octaves_max)), av_oct = av_octaves_max, 
                      Initial.State = rep('Max', length(av_octaves_max)))
  df_max = data.frame(x = seq(length(av_octaves_min)), av_oct = av_octaves_min, 
                      Initial.State = rep('Min', length(av_octaves_min)))
  df = rbind(df_min, df_max)
  
  p = ggplot(data=df, aes(x, y=av_oct, fill=Initial.State)) +
    geom_bar(stat="identity", position=position_dodge())+
    theme_minimal()+
    theme(#panel.grid.major = element_blank(), 
          panel.grid.minor = element_blank(),
          plot.title = element_text(hjust = 0.5, face = 'bold', size = 16),
          axis.text=element_text(size=12),
          axis.title=element_text(size=16), 
          legend.position = c(0.73 ,0.825),
          legend.background = element_rect(color = NA, fill = alpha('white', 0)),
          legend.spacing.y = unit(0.05, 'cm')) + 
    labs(title = 'Species abundance octave vector', x = 'n', y = 'Richness', fill = 'Initial\nDiversity') +
    scale_x_continuous(breaks = c(0.5,1.5,2.5,3.5,4.5,5.5,6.5), labels = c(0,1,2,3,4,5,6))
  print(p)
    
  
  return(cat("
  When running our neutral model from both minimal and maximal initial diversities, we arrive in both cases
  to an equilibrium in which one species dominates and the other ones are minoritary, but still exist.
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
      richness = c(richness, species_richness(community))
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
  graphics.off()
  list_files = list.files('.', pattern = 'result_')
  octaves_500 = rep(0,1); octaves_1000 = rep(0,1); octaves_2500 = rep(0,1); octaves_5000 = rep(0,1)
  #Counters for each size
  count_500 = 0; count_1000 = 0; count_2500 = 0; count_5000 = 0
  
  for (i in list_files){ #iterates over the simulations
    load(i) 
    #Get rid of the burn period
    burn = args[[6]]/args[[5]] #divide by iterval_oct to make it the same scale
    octaves_del = octaves_[-seq(burn)]
    
    #Add the elements in the current octave set to the running total per size
    if (length(community[[1]]) == 500){
      for (j in seq(length(octaves_del))){ #iterates over the generations (the ones recorded)
        octaves_500 = sum_vect(octaves_500, octaves_del[[j]])
        count_500 = count_500 + 1
      }
    } else if (length(community[[1]]) == 1000){
        for (k in seq(length(octaves_del))){
          octaves_1000 = sum_vect(octaves_1000, octaves_del[[k]])
          count_1000 = count_1000 + 1
      }
    } else if (length(community[[1]]) == 2500){
        for (l in seq(length(octaves_del))){
          octaves_2500 = sum_vect(octaves_2500, octaves_del[[l]])
          count_2500 = count_2500 + 1
          }
    } else {
          for (m in seq(length(octaves_del))){
            octaves_5000 = sum_vect(octaves_5000, octaves_del[[m]])
            count_5000 = count_5000 + 1
        }
      }

  }
  
  #Average octaves
  av_octave_500 = octaves_500/count_500; av_octave_1000 = octaves_1000/count_1000
  av_octave_2500 = octaves_2500/count_2500; av_octave_5000 = octaves_5000/count_5000
  
  #Plot in a four panel graph
  combined_results <- list(av_octave_500, av_octave_1000, av_octave_2500, av_octave_5000)
  
  av_octave_500 = combined_results[[1]]
  av_octave_1000 = combined_results[[2]]
  av_octave_2500 = combined_results[[3]]
  av_octave_5000 = combined_results[[4]]
  
  df_500 = data.frame(x = seq(length(av_octave_500)), av_oct = av_octave_500)
  df_1000 = data.frame(x = seq(length(av_octave_1000)), av_oct = av_octave_1000)
  df_2500 = data.frame(x = seq(length(av_octave_2500)), av_oct = av_octave_2500)
  df_5000 = data.frame(x = seq(length(av_octave_5000)), av_oct = av_octave_5000)
  
  
  o_500  <- ggplot(data=df_500, aes(x, y=av_oct)) +
    geom_bar(stat="identity", fill = 'steelblue1')+
    theme_minimal()+
    theme(panel.grid.major = element_blank(), 
      panel.grid.minor = element_blank(),
      axis.text=element_text(size=12)) + 
    labs(x = 'n', y = 'Richness') +
    scale_x_continuous(breaks = c(0.5,1.5,2.5,3.5,4.5,5.5,6.5,7.5,8.5,9.5 ), 
                       labels = c(0,1,2,3,4,5,6,7,8,9)) +
    annotate("text", x=Inf, y = Inf, vjust=1, hjust=1, 
             label = "L = 500", size = 5)
  
  o_1000  <- ggplot(data=df_1000, aes(x, y=av_oct)) +
    geom_bar(stat="identity", fill = 'steelblue2')+
    theme_minimal()+
    theme(panel.grid.major = element_blank(), 
      panel.grid.minor = element_blank(),
      axis.text=element_text(size=12)) + 
    labs(x = 'n', y = 'Richness') +
    scale_x_continuous(breaks = c(0.5,1.5,2.5,3.5,4.5,5.5,6.5,7.5,8.5,9.5,10.5), 
                       labels = c(0,1,2,3,4,5,6,7,8,9,10))+
    annotate("text", x=Inf, y = Inf, vjust=1, hjust=1,
             label = "L = 1000", size = 5)
  
  o_2500  <- ggplot(data=df_2500, aes(x, y=av_oct)) +
    geom_bar(stat="identity", fill = 'steelblue3')+
    theme_minimal()+
    theme(panel.grid.major = element_blank(), 
      panel.grid.minor = element_blank(),
      axis.text=element_text(size=12)) + 
    labs(x = 'n', y = 'Richness') +
    scale_x_continuous(breaks = c(0.5,1.5,2.5,3.5,4.5,5.5,6.5,7.5,8.5,9.5,10.5,11.5 ), 
                       labels = c(0,1,2,3,4,5,6,7,8,9,10,11))+
    annotate("text", x=Inf, y = Inf, vjust=1, hjust=1,
             label = "L = 2500", size = 5)
  
  o_5000  <- ggplot(data=df_5000, aes(x, y=av_oct)) +
    geom_bar(stat="identity", fill = 'steelblue4')+
    theme_minimal()+
    theme(panel.grid.major = element_blank(), 
      panel.grid.minor = element_blank(),
      axis.text=element_text(size=12)) + 
    labs(x = 'n', y = 'Richness') +
    scale_x_continuous(breaks = c(0.5,1.5,2.5,3.5,4.5,5.5,6.5,7.5,8.5,9.5,10.5,11.5,12.5 ), 
                       labels = c(0,1,2,3,4,5,6,7,8,9, 10, 11,12))+
    annotate("text",x=Inf, y = Inf, vjust=1, hjust=1,
             label = "L = 5000", size = 5)
  ggsave(filename = 'hpc_octave_vectors.pdf', plot = last_plot(), path = '.',
         scale = 3, width = 8, height = 6, units = 'cm')
  
  figure <- ggarrange(o_500, o_1000, o_2500, o_5000, 
                      labels = c("A", "B", "C", 'D'),
                      ncol = 2, nrow = 2)
  annotate_figure(figure,
                  top = text_grob("Averaged abundance octaves",
                                  face = "bold", size = 18))
  print(figure)
  
  return(combined_results)
}

# Question 21
question_21 <- function()  {
  n = 3
  t = 8
  D = log(n)/log(t)
  answer = list(D, 'The answer is the solution to the equation n^D = t, where n is the ratio by 
  which we are increasing the fundamental element, and t is the number of 
  fundamental elements we have when we increas it by n amount, and D is the dimension')
  return(answer)
}

# Question 22
question_22 <- function()  {
  n = 3
  t = 20
  D = log(n)/log(t)
  answer = list(D, 'The answer is the solution to the equation n^D = t, where n is the ratio by 
  which we are increasing the fundamental element, and t is the number of 
  fundamental elements we have when we increas it by n amount')
  return(answer)
}

# Question 23
chaos_game <- function(it = 100000) {
  # clear any existing graphs and plot your graph within the R window
  graphics.off()
  #Points
  x = c(0,3,4,0,4,1)
  init_points = matrix(x, nrow = length(x)/2, ncol = 2)
 
#Generate dataframe with half movements towards randomly chosen principal points.
  
  points = matrix(rep(0,2*it), nrow = it, ncol = 2)
  for (i in seq(it-1)){
    #Choose a point
    ind = sample(seq(dim(init_points)[1]),1)
    points[i+1,] = 0.5 * (points[i,] + init_points[ind,])
  }
  #Plot the first poin
  df_init = data.frame(init_points, color = rep('blue', dim(init_points)[1]), 
                  sizes = rep(1.5,dim(init_points)[1]))
  df_points = data.frame(points, color = rep('magenta', dim(points)[1]), 
                  sizes = rep(1, dim(points)[1]))     
  df = rbind(df_init, df_points)
  p = ggplot(df, aes(X1, X2)) + 
    geom_point(aes(color = color, size = sizes)) +
    theme_classic()+
    theme(legend.position = 'none', plot.title = element_text(size = 18),
          axis.title.x = element_blank(), axis.title.y = element_blank() )+
    labs(title = 'Chaos Game')
  print(p)
  
  
return(df)
}

# Question 24
turtle <- function(start_position, direction, length)  {
  #Calculate endpoint coordinates
  Bx = length*cos(direction) + start_position[1]
  By = length*sin(direction) + start_position[2]
  segments(x0=start_position[1], y0 = start_position[2], x1 = Bx, y1 = By, col = 'green')
  
  return(c(Bx,By)) # you should return your endpoint here.
}

# Question 25
elbow <- function(start_position, direction, length)  {
  end = turtle(start_position, direction, length)
  turtle(start_position = end, direction = direction - pi/4, length = 0.95*length)
}

# Question 26
spiral <- function(start_position, direction, length)  {
  end = turtle(start_position, direction, length)
  if (length>1e-10){spiral(start_position = end, direction - pi/4 , length= 0.9*length )}
  else{return("The spiral function calls itself undefinetly until the line is too small compared to the precision
         of the computer to be drawn.")}
}

# Question 27
draw_spiral <- function()  {
  # clear any existing graphs and plot your graph within the R window
  graphics.off()
  plot.new()
  plot.new()
  plot.window(xlim=c(0,16), ylim=c(-5,10))
  axis(1)
  axis(2)
  text = spiral(start_position = c(0,15), direction = 0, length = 10)
  return(text)
}

# Question 28
tree <- function(start_position, direction, length)  {
  end = turtle(start_position, direction, length)
  if (length>0.01){
    tree(start_position = end, direction - pi/4 , length= 0.65*length)
    tree(start_position = end, direction + pi/4 , length= 0.65*length)
    }
}
draw_tree <- function()  {
  # clear any existing graphs and plot your graph within the R window
  graphics.off()
  plot.new()
  plot.new()
  plot.window(xlim=c(0,10), ylim=c(0,10))
  axis(1)
  axis(2)
  tree(start_position = c(5,0), direction = pi/2, length = 3.5)
}

# Question 29
fern <- function(start_position, direction, length)  {
  end = turtle(start_position, direction, length)
  if (length>0.02){
    fern(start_position = end, direction + pi/4 , length= 0.38*length)
    fern(start_position = end, direction , length= 0.87*length)
  }
}
draw_fern <- function()  {
  # clear any existing graphs and plot your graph within the R window
  graphics.off()
  plot.new()
  plot.new()
  plot.window(xlim=c(-5,5), ylim=c(0,18))
  axis(1)
  axis(2)
  fern(start_position = c(0,0), direction = pi/2, length = 2)
}

# Question 30
fern2 <- function(start_position, direction, length, dir = 1)  {
  end = turtle(start_position, direction, length)
  if (length>0.02){
    fern2(start_position = end, direction + dir*pi/6, length= 0.38*length, dir)
    fern2(start_position = end, direction , length= 0.87*length, dir*-1)
  }
}
draw_fern2 <- function()  {
  # clear any existing graphs and plot your graph within the R window
  graphics.off()
  plot.new()
  plot.new()
  plot.window(xlim=c(-5,5), ylim=c(0,18))
  axis(1)
  axis(2)
  fern2(start_position = c(0,0), direction = pi/2, length = 2)
}


# Challenge questions - these are optional, substantially harder, and a maximum of 16% is available for doing them.  

# Challenge question A
Challenge_A <- function(speciation_rate = 0.1, size = 100, n_sim = 100, 
                        duration = 36, rec = 3, conf = 0.972){
  # clear any existing graphs and plot your graph within the R window
  graphics.off()
  richness_max = matrix(data = 0,  ncol = 1 + floor(duration/rec), nrow = n_sim)
  richness_min = matrix(data = 0,  ncol = 1 + floor(duration/rec), nrow = n_sim)
  sim = 1
  while (sim <= n_sim){
    #Calculate initial values for each simulation
    community_max= init_community_max(size)
    community_min= init_community_min(size)
    richness_max[sim,1] = richness_max[sim,1] + species_richness(community_max)
    richness_min[sim,1] = richness_min[sim,1] + species_richness(community_min)
    for (i in seq(duration)){
      community_max = neutral_generation_speciation(community_max, speciation_rate)
      community_min = neutral_generation_speciation(community_min, speciation_rate)
      if (i %% rec == 0) {
        richness_max[sim, i/rec+1] = richness_max[sim, i/rec+1] + 
          species_richness(community_max)
        richness_min[sim, i/rec+1] = richness_min[sim, i/rec+1] + 
          species_richness(community_min)
      }
    }
    sim = sim + 1
  }
  z = qnorm(conf, mean = 0, sd = 1)
  mean_richness_max = colMeans(richness_max)
  err_max = apply(richness_max, 2, sd)*z/sqrt(nrow(richness_max))
  mean_richness_min = colMeans(richness_min)
  err_min = apply(richness_min, 2, sd)*z/sqrt(nrow(richness_min))
  mean_richness = cbind(t(mean_richness_max), t(mean_richness_min))
  err = cbind(t(err_max), t(err_min))
  init = c(rep('max',floor(duration/rec)+1), 
           rep('min',floor(duration/rec)+1))
  
  df = data.frame(gen = c(0,seq(rec,duration, rec)), 
                  mean_richness = t(mean_richness),
                  err = t(err), r_0 = init)

  plt = ggplot(data=df, aes(x = gen, y = mean_richness, fill = r_0)) +
    geom_bar(position = "identity", stat="identity") +
    geom_errorbar(aes(ymin=mean_richness-err, ymax=mean_richness+err), 
                  width = 0.5) +
    theme(axis.title.x = element_text(size = 16, face = 'bold'),
          axis.title.y = element_text(size = 16, face = 'bold'),
          axis.text=element_text(size=14),
          axis.text.y = element_text(margin = margin(r = 0)),
          panel.grid.major = element_line(color = 'grey', size = 0.1), 
          panel.grid.minor = element_blank(), 
          panel.background = element_rect(fill = 'white'), 
          legend.position = c(0.2, 0.8), 
          legend.background = element_rect(fill=alpha('white', 0.4)), 
          legend.title=element_text(size=16),
          legend.text=element_text(size=16)) +
    scale_y_continuous(expand = c(0,0)) +
    scale_x_continuous(breaks = seq(0,36,6)) +
    labs( x="t (generations)", y = "mean species richness")
  
  return(plt)
}
# Challenge question B
Challenge_B <- function(size = 100, speciation_rate = 0.1, duration = 36, n_sim = 20) {
  # clear any existing graphs and plot your graph within the R window
  graphics.off()
  init_richness =seq(from = 10, to = size, by = 10)
  tot_lines = matrix(data = 0, nrow = duration + 1 , ncol = length(init_richness))
  for (i in init_richness){
    sim = 1
    #Initialite the matrix of richness
    richness = matrix(data = 0, nrow = duration + 1 , ncol = n_sim)
    community = c(seq(i), sample(i, size-i, replace = T))
    while (sim <= n_sim){
      richness[,sim] = neutral_time_series_speciation(community = community, 
                                                    speciation_rate = speciation_rate, 
                                                    duration = duration)
      sim = sim + 1
    }
    mean_richness = rowMeans(richness)
    tot_lines[,i/10] = mean_richness

  }
  dat = melt(tot_lines)
  p = ggplot(data = dat, aes(x = Var1, y = value, group = Var2)) +
    geom_line(aes(color = Var2)) +
    theme(axis.title.x = element_text(size = 16),
          axis.title.y = element_text(size = 16),
          axis.text=element_text(size=14),
          axis.text.y = element_text(margin = margin(r = 0)),
          panel.grid.major = element_line(color = 'grey', size = 0.1), 
          panel.grid.minor = element_blank(), 
          panel.background = element_rect(fill = 'white'), 
          legend.position="none",
          plot.title = element_text(size = 20, face = 'bold')) +
    scale_y_continuous(breaks=seq(10,100,30)) +
    scale_x_continuous(expand = c(0.05, 0.01)) +
    scale_color_gradientn(colours = rainbow(11)) +
    labs(title = 'Averaged species richness\nfor different initial conditions', 
         x="t (generations)", y = "mean species richness")
  
  return(p)
}

Challenge_B_alternative <- function(size = 100, speciation_rate = 0.1, duration = 36) {
  # clear any existing graphs and plot your graph within the R window
  graphics.off()
  init_richness = seq(size)
  #Initialite the matrix of richness
  richness = matrix(data = 0, nrow = duration + 1, ncol = size)
  for (i in init_richness){
    #Select what species will be in my community
    #species_identities = sample(size, i, replace = T)
    #From those species, create a community with that richness
    community = c(seq(i), sample(i, size-i, replace = T))
    #Apply time series for each initial richness
    richness[,i] = neutral_time_series_speciation(community = community, 
                                                  speciation_rate = speciation_rate, 
                                                  duration = duration)
  }
  mean_richness = rowMeans(richness)
  x = rep(seq(dim(richness)[1]), dim(richness)[2] + 1)
  lines = c(as.numeric(matrix(richness)), mean_richness)
  group = rep((1:(dim(richness)[2]+1)), each = dim(richness)[1])
  color = c(rep('grey', length(richness)),rep('green', length(mean_richness)))
  size = c(rep(0.1, length(richness)),rep(0.7, length(mean_richness)))  
  df = data.frame(x = x, y = lines, color = color, size = size, group = group)
  
  p = ggplot(data = df, aes( x = x, y = y, group = group)) +
    geom_line(aes(color = color), size = size) +
    scale_color_manual(values=c("black", "grey"))+
    theme(axis.title.x = element_text(size = 16, face = 'bold'),
          axis.title.y = element_text(size = 16, face = 'bold'),
          axis.text=element_text(size=14),
          axis.text.y = element_text(margin = margin(r = 0)),
          panel.grid.major = element_line(color = 'grey', size = 0.1), 
          panel.grid.minor = element_blank(), 
          panel.background = element_rect(fill = 'white'), 
          legend.position="none") +
    scale_fill_discrete(name = "New Legend Title") +
    labs( x="t (generations)", y = "species richness")
  
  return(p)
}

#Auxiliary functions for Challenge_C

load_Challenge_C  = function(cut = 3000){
  #Load rda files
  list_files = list.files('.', pattern = 'result_')
  #Preallocate richnes matrices
  richness_500 = matrix(data = 0, nrow = length(list_files)/4, ncol = 4001)
  richness_1000 = matrix(data = 0, nrow = length(list_files)/4, ncol = 8001)
  richness_2500 = matrix(data = 0, nrow = length(list_files)/4, ncol = 20001)
  richness_5000 = matrix(data = 0, nrow = length(list_files)/4, ncol = 40001)
  #Create the 
  j = 1; k = 1; l = 1; m = 1
  for (i in list_files){ #iterates over the simulations
    load(i)
    if (length(community[[1]]) == 500){
      richness_500[j,] = richness[[1]]
      j = j + 1
    } else if (length(community[[1]]) == 1000){
      richness_1000[k,] = richness[[1]]
      k = k + 1
    } else if (length(community[[1]]) == 2500){
      richness_2500[l,] = richness[[1]]
      l = l + 1
    } else {
      richness_5000[m,] = richness[[1]]
      m = m + 1
    }
  }
  #Average and only get first 'cut' elements for plotting clarity
  
  richness_500_av = colMeans(richness_500)[1:cut]
  richness_1000_av = colMeans(richness_1000)[1:cut]
  richness_2500_av = colMeans(richness_2500)[1:cut]
  richness_5000_av = colMeans(richness_5000)[1:cut]
  #Load fitted models
  curves = c(richness_500_av, richness_1000_av, 
             richness_2500_av, richness_5000_av)
  group = c(rep(0, length(richness_500_av)), rep(1, length(richness_1000_av)), 
            rep(2, length(richness_2500_av)), rep(3, length(richness_5000_av)))
  x = c(seq(length(richness_500_av)), seq(length(richness_1000_av)), 
        seq(length(richness_2500_av)), seq(length(richness_5000_av)))
  df = data.frame(x = x, curves = curves, group = group) 
  
  return(df)
}

fitting_Challenge_C = function(){
  
  df = load_Challenge_C()
  
  df_500 = subset(df, group == 0)
  df_1000 = subset(df, group == 1)
  df_2500 = subset(df, group == 2)
  df_5000 = subset(df, group == 3)
  
  #Perform fitting
  fitmodel_500 <- nls(curves ~ a * (1 - 1/(x^b)) ,
                      data = df_500,
                      start=list(a=11, b = 0.5),      
                      trace=T)
  
  fitmodel_1000 = nls(curves ~ a * (1 - 1/(x^b)) ,
                      data = df_1000,
                      start=list(a=20, b=0.5),      
                      trace=T)
  
  fitmodel_2500 = nls(curves ~ a * (1 - 1/(x^b)) ,
                      data = df_2500,
                      start=list(a=41, b=0.5),      
                      trace=T)
  
  fitmodel_5000 = nls(curves ~ a * (1 - 1/(x^b)) ,
                      data = df_5000,
                      start=list(a=110, b=0.5),      
                      trace=T)
  
  #Group models in one list for return
  models = list(fitmodel_500, fitmodel_1000, 
                fitmodel_2500, fitmodel_5000)
  
  return(models)
}

predictions = function(){
  
  models = fitting_Challenge_C()
  #Get prediction for curves
  curve_500 = predict(models[[1]])
  curve_1000 = predict(models[[2]])
  curve_2500 = predict(models[[3]])
  curve_5000 = predict(models[[4]])
  
  #Create dataframe
  curves_pred = c(curve_500, curve_1000, curve_2500, curve_5000)
  x = c(seq(length(curve_500)), seq(length(curve_1000)), 
        seq(length(curve_2500)), seq(length(curve_5000)))
  group = c(rep(0, length(curve_500)), rep(1, length(curve_1000)), 
            rep(2, length(curve_2500)), rep(3, length(curve_5000)))
  
  df_pred = data.frame(x = x, y = curves_pred, group = group)
  
  return(df_pred)
}

stable_state = function(b, p = 0.7){
  return(1/(1-p)^(1/b))
}

# Challenge question C
Challenge_C <- function() {
  # clear any existing graphs and plot your graph within the R window
  graphics.off()
  df = load_Challenge_C()
  
  #Load model predictions
  df_pred = predictions()
  
  # #To determine where do they reach stable state, we impose that the y value must be
  # #0.99*a, with a being the value of the asymptote of the function 
  # #f(x) = a * (1 - 1/(x)^b)
  # 
  models = fitting_Challenge_C()
  b = c()
  for (i in seq(length(models))){
    b = c(b,as.numeric(coef(models[[i]]))[2])
  }
  
  vlines = stable_state(b)
  df_lines = data.frame(vlines = vlines, 
                        color = c("#FF0000FF", "#80FF00FF", 
                                  "#8000FFFF", "#00FFFFFF"))
  
  p = ggplot(data = df, aes(x = x, y = curves, group = group, 
                            color = as.factor(group) )) +
    geom_line() +
    
    geom_line(data = df_pred, aes(x = x, y = y, group = group), color= 'black',
              show.legend = F) +
    
    geom_vline(aes(xintercept = vlines),
               color = c("#FF0000FF", "#80FF00FF", "#8000FFFF", "#00FFFFFF"),
               linetype = "dashed",
               size = 0.7,
               data = df_lines,
               show.legend = F) +
    
    theme(
      plot.title = element_text(size = 20, face = 'bold'), 
      axis.title.x = element_text(size = 16),
      axis.title.y = element_text(size = 16),
      axis.text=element_text(size=14),
      axis.text.y = element_text(margin = margin(r = 0)),
      panel.grid.major = element_line(color = 'grey', size = 0.1),
      panel.grid.minor = element_blank(),
      panel.background = element_rect(fill = 'white'),
      legend.position = c(0.25, 0.7), 
      legend.title = element_text(size = 18), 
      legend.key = element_rect(colour = NA, fill = NA),
      legend.text=element_text(size=12),
      legend.key.size = unit(2,"line"),
      legend.background = element_rect(fill = "transparent")) +
      
    scale_color_manual(name = "",
                       values = c(rainbow(4)[1], rainbow(4)[2], 
                                  rainbow(4)[3], rainbow(4)[4]),
                       labels = c("L = 500", "L = 1000", 
                                  "L = 2500", "L = 5000")) +
    labs(title = 'Averaged species richness\nfor different sizes',
         x="t (generations)", y = "mean species richness") +
    
    annotate('text', x=600, y=15, label = "paste(italic(t) [stable], \" = 121\")", 
             parse = TRUE, color = rainbow(4)[1], fontface="bold", size = 5) +
    
    annotate('text', x=600, y=26, label = "paste(italic(t) [stable], \" = 306\")",
             parse = TRUE, color = rainbow(4)[2], fontface="bold", size = 5) +
    
    annotate('text', x=1980, y=62, label ="paste(italic(t) [stable], \" = 1664\")",
             parse = TRUE, color = rainbow(4)[3], fontface="bold", size = 5) +
    
    annotate('text', x=1980, y=120, label = "paste(italic(t) [stable], \" = 2208\")",
             parse = TRUE, color = rainbow(4)[4], fontface="bold", size = 5)
  
 
  return(p)
}
Challenge_C()
#Challenge question D
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


