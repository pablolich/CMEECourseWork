# CMEE 2019 HPC excercises R code main proforma
# you don't HAVE to use this but it will be very helpful.  
#If you opt to write everything yourself from scratch please ensure you use EXACTLY 
#the same function and parameter names and beware that you may loose marks if it 
#doesn't work properly because of not using the proforma.

library(ggplot2)
library(ggpubr)
library(ggrepel)

name <- "Pablo Lechon"
preferred_name <- "Pablo"
email <- "plechon@ucm.es"
username <- "pl1619"
# will be assigned to each person individually in class and should be between 0.002 and 0.007
personal_speciation_rate <- 0.00403

# Question 1
species_richness <- function(community){
  #Returns species richness
  return(length(unique(community)))
}

# Question 2
init_community_max <- function(size){
  #Returns a sorted sequence with the specified size
  return(seq(size))
}

# Question 3
init_community_min <- function(size){
  #Returns a vector of ones of the specified size
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
  #If the community consists of x individuals, then x/2 inidividual neutral steps will
  #correspond to a complete generation for taxa being simulated.
  switch = 0
  if (length(community)%%2 == 1){
    #If the number is odd, set switch to 0.5 or -0.5 to summ it to the result, and 
    #round up or down to the nearest whole number to determine generation length
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
    #Perform a generation of neutral steps
    community = neutral_generation(community)
    #Calculates richness after each generation 
    richness[i] = species_richness(community)
  }
  #Note that richness is a vector with length duration + 1 (initial richness)
  return(richness)
}


# Question 8
question_8 <- function() {
  size = 100
  generations = 200
  # clear any existing graphs and plot your graph within the R window
  graphics.off()
  #Get vector of richness for each generation during duration
  y = neutral_time_series(community = init_community_max(size), duration = generations)
  x = seq(generations + 1)
  df = data.frame(x, y)
  
  #Plot
  p = ggplot(df, aes(x, y)) + 
    geom_point(size = 1.5) + 
    theme_bw() + 
    theme(panel.grid.major = element_blank(), 
          panel.grid.minor = element_blank(),
          plot.title = element_text(hjust = 0.5, face = 'bold', size = 16),
          axis.text=element_text(size=12),
          axis.title=element_text(size=16)) +
    labs(title = 'Time series of Neutral Model', x = 'Generations', y = 'Richness')
  
  #Show plot
  print(p)
  
  return(cat('
  The system always converges to a stable state of 1 species.
  After every generation, some species go extinct, and others reproduce to occupy their positions, 
  decreasing the species richness because the community vector now has repeated species labels.
  Therefore, the stable state with one species is always reached because the function choose_two is more 
  likely to chose a position occupied with a repeated species id.
             '))
}

# Question 9
neutral_step_speciation <- function(community, speciation_rate){
  #Performs a step of neutral model with speciation
  
  #Get index to be replaced
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
    #Perform a generation of neutral steps
    community = neutral_generation_speciation(community, speciation_rate)
    #Calculates richness after a generation has passed
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
  
  #Get time series with maximum and minimum initial conditions
  time_series_max = neutral_time_series_speciation(community = init_community_max(size), 
                                                   duration = generations,
                                                   speciation_rate = speciation_rate)
  time_series_min = neutral_time_series_speciation(community = init_community_min(size), 
                                                   duration = generations,
                                                   speciation_rate = speciation_rate)
  
  #Prepare data for plot
  x = seq(generations + 1)
  dfmin = data.frame(x, time_series = time_series_min, Initial.State = rep('Min', length(time_series_min)))
  dfmax = data.frame(x, time_series = time_series_max, Initial.State = rep('Max', length(time_series_max)))
  df = rbind(dfmin, dfmax)
  
  #Plot
  p = ggplot(df, aes(x, time_series, color = Initial.State)) + 
    geom_point(size = 0.7) + 
    geom_line(size = 0.2)+
    theme_bw() + 
    theme(panel.grid.major = element_blank(), 
          panel.grid.minor = element_blank(),
          plot.title = element_text(hjust = 0.5, face = 'bold', size = 16),
          axis.text=element_text(size=12),
          axis.title=element_text(size=16), 
          legend.position = c(0.3,0.85),
          legend.background = element_rect(linetype = 1, color = 'white', size = 0.2,),
          legend.text=element_text(size=12),
          legend.title=element_text(size=14)) + 
    labs(title = 'Time series of Neutral Model with speciation', x = 'Generations', y = 'Richness', 
         col = 'Initial Diversity') 
  
  #Show plot
  print(p)
  
  return(cat('
  The stable state of this system is independent of the initial condition. By adding a speciation rate 
  term, we are forcing mutations to happen. Therefore, the stable state is not static, but a dynamic 
  equilibrium state where the richness of both initial states converges to a non-one average value after
  certain number of generations.
             '))
}

# Question 13
species_abundance <- function(community){
  #Calculate the abundance of species in a community
  return(sort(as.numeric(table(community)), decreasing = T))
}

# Question 14
octaves <- function(abundance_vector){
  #Calculate octaves for a given abundance vector
  return(tabulate(floor(log2(abundance_vector))+1))
}
# Question 15
sum_vect <- function(x, y) {
  #Sums vector of different lengths by adding 0 to the shorter vector until
  #both lengths are equal
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
  
  #Set parameters for calculations
  init_gen = 200
  stable_state = 2000
  speciation_rate = 0.1
  record = 20
  
  #Generate communities of minimum and maximum diversities
  community_min = init_community_min(100)
  community_max = init_community_max(100)
  octaves_min = 0
  octaves_max = 0
  #Apply generation with speciation to both communities for init_gen + stable_state generations
  for (i in seq(init_gen + stable_state)){
    community_min = neutral_generation_speciation(community_min, speciation_rate)
    community_max = neutral_generation_speciation(community_max, speciation_rate)
    #If we are in the burn in period has ended, and i is a multiple of record, 
    #we record the octave
    if (i >= init_gen){
      if (i%%record == 0){
        #Cum sum octaves
        octaves_min = sum_vect(octaves_min, octaves(species_abundance(community_min)))
        octaves_max = sum_vect(octaves_max, octaves(species_abundance(community_max)))
      }
    }
  }
  
  #Average octaves
  #Note the division by record, to take into account that we have not recorded octaves
  #every generation
  av_octaves_min = octaves_min/(stable_state/record)
  av_octaves_max = octaves_max/(stable_state/record)
  
  #Prepare data for plotting
  df_min = data.frame(x = seq(length(av_octaves_max)), av_oct = av_octaves_max, 
                      Initial.State = rep('Max', length(av_octaves_max)))
  df_max = data.frame(x = seq(length(av_octaves_min)), av_oct = av_octaves_min, 
                      Initial.State = rep('Min', length(av_octaves_min)))
  df = rbind(df_min, df_max)
  
  #Plot
  p = ggplot(data=df, aes(x, y=av_oct, fill=Initial.State)) +
    geom_bar(stat="identity", position=position_dodge())+
    theme_minimal()+
    theme(#panel.grid.major = element_blank(), 
          panel.grid.minor = element_blank(),
          plot.title = element_text(hjust = 0.5, face = 'bold', size = 16),
          axis.text=element_text(size=12),
          axis.title=element_text(size=16), 
          legend.position = c(0.73 ,0.9),
          legend.background = element_rect(color = NA, fill = alpha('white', 0)),
          legend.spacing.y = unit(0.05, 'cm'), 
          legend.title = element_text(size = 14),
          legend.text = element_text(size = 12)) + 
    labs(title = 'Species abundance octave vector', x = 'n', y = 'Richness', fill = 'Initial\nDiversity') +
    scale_x_continuous(breaks = c(0.5,1.5,2.5,3.5,4.5,5.5,6.5), labels = c(0,1,2,3,4,5,6))
  
  #Show plot
  print(p)
  
  return(cat("
  Different initial conditions of the system lead to the same final octave vectors. This is due to the 
  stable state of the system being independent of the initial conditions. The species distribution 
  in the stable state will inherit that property, wich will also be passed to the octave vector of the 
  stable state since it is merely a rescaling on the x-axis.
             "))
  
}

# Question 17
cluster_run <- function(speciation_rate, size, wall_time, interval_rich, interval_oct, 
                        burn_in_generations, output_file_name){
  #This function applies neutral generations to a community for a predefined amount of time
  #(wall_time) and stores the species richness and octaves every interval_rich and 
  #interval_oct generations respectively. It also stores the community vector and the 
  #function arguments. All these are outputet to an .rda file
  
  #Initialize community with minimum richness
  community = init_community_min(size)
  #Initialite parameters
  richness = c()
  octaves_ = list()
  i = 1
  generation = 0 #To record the initial richness
  #divide by 60 to transform to minutes
  
  #Start recording time
  ptm <- proc.time()
  while (as.numeric((proc.time() - ptm)[3]) <= (wall_time*60)){
    #When generation reaches an interval_rich multiple, and the burn-in period has ended,
    #calculate richness and store it.
    if ((generation %% interval_rich == 0) & (generation <= burn_in_generations)){
      richness = c(richness, species_richness(community))
    }
    #When generation reaches an interval_oct multiple, calculate octave and store it
    if (generation %% interval_oct == 0){
      octaves_ = c(octaves_, list(octaves(species_abundance(community))))
    }
    #Update community by one neutral generation with speciation
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
process_cluster_results <- function(print = T){
  # clear any existing graphs and plot your graph within the R window
  graphics.off()
  
  #List all files from the HPC simulations
  list_files = list.files('.', pattern = 'result_')
  #Initialite octaves and counters for each size
  octaves_500 = rep(0,1); octaves_1000 = rep(0,1); octaves_2500 = rep(0,1); octaves_5000 = rep(0,1)
  count_500 = 0; count_1000 = 0; count_2500 = 0; count_5000 = 0
  
  for (i in list_files){ #iterates over the simulations
    #Loads the .rda file
    load(i) 
    #Get rid of the burn period
    burn = args[[6]]/args[[5]] #divide by iterval_oct to make it the same scale
    octaves_del = octaves_[-seq(burn)]
    
    #Add the elements in the current octave set to the running total per size add updates
    #counter per size
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
  
  #Prepare data for plotting
  df_500 = data.frame(x = seq(length(av_octave_500)), av_oct = av_octave_500)
  df_1000 = data.frame(x = seq(length(av_octave_1000)), av_oct = av_octave_1000)
  df_2500 = data.frame(x = seq(length(av_octave_2500)), av_oct = av_octave_2500)
  df_5000 = data.frame(x = seq(length(av_octave_5000)), av_oct = av_octave_5000)
  
  #Plot
  o_500  <- ggplot(data=df_500, aes(x, y=av_oct)) +
    geom_bar(stat="identity", fill = '#A35638')+ #Use bar plots
    theme_minimal()+ #Set predefined theme
    theme(panel.grid.major = element_blank(), #Get rid of ggplot grid
      panel.grid.minor = element_blank(),
      axis.text=element_text(size=12)) + #Increase size of text in axis
    labs(x = NULL, y = NULL) + #Get rid of individual axis labels
    scale_x_continuous(breaks = c(0.5,1.5,2.5,3.5,4.5,5.5,6.5,7.5,8.5,9.5 ), #Set x scale
                       labels = c(0,1,2,3,4,5,6,7,8,9)) +
    annotate("text", x=5, y = Inf, vjust=1, hjust='center', #Set and format labels
             label = "L = 500", size = 5)
  
  o_1000  <- ggplot(data=df_1000, aes(x, y=av_oct)) +
    geom_bar(stat="identity", fill = '#E08F62')+
    theme_minimal()+
    theme(panel.grid.major = element_blank(), 
      panel.grid.minor = element_blank(),
      axis.text=element_text(size=12)) + 
    labs(x = NULL, y = NULL) +
    scale_x_continuous(breaks = c(0.5,1.5,2.5,3.5,4.5,5.5,6.5,7.5,8.5,9.5,10.5), 
                       labels = c(0,1,2,3,4,5,6,7,8,9,10))+
    annotate("text", x=5, y = Inf, vjust=1, hjust='center',
             label = "L = 1000", size = 5)
  
  o_2500  <- ggplot(data=df_2500, aes(x, y=av_oct)) +
    geom_bar(stat="identity", fill = '#D7C79E')+
    theme_minimal()+
    theme(panel.grid.major = element_blank(), 
      panel.grid.minor = element_blank(),
      axis.text=element_text(size=12)) + 
    labs(x = NULL, y = NULL) +
    scale_x_continuous(breaks = c(0.5,1.5,2.5,3.5,4.5,5.5,6.5,7.5,8.5,9.5,10.5,11.5 ), 
                       labels = c(0,1,2,3,4,5,6,7,8,9,10,11))+
    annotate("text", x=5, y = Inf, vjust=1, hjust='center',
             label = "L = 2500", size = 5)
  
  o_5000  <- ggplot(data=df_5000, aes(x, y=av_oct)) +
    geom_bar(stat="identity", fill = '#9DAB86')+
    theme_minimal()+
    theme(panel.grid.major = element_blank(), 
      panel.grid.minor = element_blank(),
      axis.text=element_text(size=12)) + 
    labs(x = NULL, y = NULL) +
    scale_x_continuous(breaks = c(0.5,1.5,2.5,3.5,4.5,5.5,6.5,7.5,8.5,9.5,10.5,11.5,12.5 ), 
                       labels = c(0,1,2,3,4,5,6,7,8,9, 10, 11,12))+
    annotate("text",x=6, y = Inf, vjust=1, hjust='center',
             label = "L = 5000", size = 5)
  
  #Merge all plots in one panel
  figure <- ggarrange(o_500, o_1000, o_2500, o_5000, 
                      labels = NULL,
                      ncol = 2, nrow = 2)
  #Annotate common title and axis for all figures
  figure <- annotate_figure(figure,
                  top = text_grob("Averaged abundance octaves",
                                  face = "bold", size = 18), 
                  bottom = text_grob('n', face = 'bold', size = 16), 
                  left = text_grob('Richness', face = 'bold', size  = 16, rot = 90))
  
  #If wished, show plot
  if (print == T){
    print(figure)
  }
  
  #Combine and save results to a .rda file
  combined_results <- list(av_octave_500, av_octave_1000, av_octave_2500, av_octave_5000)
  save(combined_results, file = 'pl1619_cluster_results.rda')
  
  return(combined_results)
}

# Question 21
question_21 <- function()  {
  #Set parameters according to specific fractal
  n = 3
  t = 8
  #Calculate dimension
  D = log(t)/log(n)
  #Format answer
  answer = list(D, 'The answer is the solution to the equation n^D = t, where n (3 in this case) 
  is the ratio by which we are increasing the fundamental element, and t (8 in our case) is the 
  number of fundamental elements we have when we increase it by n amount, and D is the dimension')
  return(answer)
}

# Question 22
question_22 <- function()  {
  #Set parameters according to specific fractal
  n = 3
  t = 20
  #Calculate dimension
  D = log(t)/log(n)
  #Format answer
  answer = list(D, 'The answer is the solution to the equation n^D = t, where n (3 in this case)
  is the ratio by which we are increasing the fundamental element, and t (20 in our case) is the 
  number of fundamental elements we have when we increase it by n amount')
  return(answer)
}

# Question 23
chaos_game <- function(it = 100000) {
  # clear any existing graphs and plot your graph within the R window
  graphics.off()
  
  #Create a matrix with initial points
  x = c(0,3,4,0,4,1)
  init_points = matrix(x, nrow = length(x)/2, ncol = 2)

  #Prealocate matrix to store the simulation results 
  points = matrix(rep(0,2*it), nrow = it, ncol = 2)
  
  for (i in seq(it-1)){
    #Choose a point
    ind = sample(seq(dim(init_points)[1]),1)
    #Calculate coordinates of next point based on the half distance rule
    points[i+1,] = 0.5 * (points[i,] + init_points[ind,])
  }
  
  #Prepare data for plotting
  df_init = data.frame(init_points, color = rep('blue', dim(init_points)[1]), 
                  sizes = rep(1.5,dim(init_points)[1]))
  df_points = data.frame(points, color = rep('magenta', dim(points)[1]), 
                  sizes = rep(1, dim(points)[1]))     
  df = rbind(df_init, df_points)
  
  #Plot
  p = ggplot(df, aes(X1, X2, 
                     #Differenciate initial points from simulated points
                     color = color, 
                     size = as.factor(sizes),
                     shape = as.factor(sizes), 
                     fill =  as.factor(sizes))) + 
    geom_point() + #Scatter plot
    theme_bw()+
    theme(legend.position = 'none', 
          plot.title = element_text(size = 18),
          axis.title.x = element_blank(), #No axes titles in x or y
          axis.title.y = element_blank() , 
          panel.grid.major = element_blank(), panel.grid.minor = element_blank())+ #Get rid of grids
    #set size, shape and color of points
    scale_size_manual(values=c(0.01,3)) +
    scale_shape_manual(values = c(20, 25)) +
    scale_fill_manual(values = c('blue', 'red')) +
    labs(title = 'Chaos Game') #Set title of plot
  
  #Show plot
  print(p)
  
return(cat('
A fractal is generated which fundamental unit is a triangle with an inverted inscribed triangle stripped
from it.
           '))
}

# Question 24
turtle <- function(start_position, direction, length, col = 'green'){
  #Draw a line of a given length from a given point and in a given direction
  #Calculate endpoint coordinates
  Bx = length*cos(direction) + start_position[1]
  By = length*sin(direction) + start_position[2]
  #Draw the segments
  #Note that the segments command assumes that a canvas in which to plot has already been created
  segments(x0=start_position[1], y0 = start_position[2], x1 = Bx, y1 = By, col)
  
  return(c(Bx,By))
}

# Question 25
elbow <- function(start_position, direction, length)  {
  #Draw a pair of lines by calling turtle that hoin together with a given angle between them
  #Assign endpoint coordinates to end
  end = turtle(start_position, direction, length)
  #Use end as the starting position for the next line and change the direction by -pi/4
  turtle(start_position = end, direction = direction - pi/4, length = 0.95*length)
}

# Question 26
spiral <- function(start_position, direction, length, col){
  #Iterative function to draw a spiral
  end = turtle(start_position, direction, length, col)
  #The spiral gets drown by changing the direction by pi/4 and decreasing the length
  #by a factor of 0.9.
  #When the drown line is too small, the spiral function stops calling itself
  if (length>1e-10){spiral(start_position = end, direction - pi/4 , length= 0.9*length, col)}
  else{return("The spiral function calls itself indefinitely until the line is too small compared to the precision
         of the computer to be drawn.")}}

# Question 27
draw_spiral <- function(col = 'burlywood4')  {
  # clear any existing graphs and plot your graph within the R window
  graphics.off()
  
  #Prepare canvas to draw spiral
  #Open a new plot
  plot.new()
  #Set dimensions of the canvas
  plot.window(xlim = c(0,18), ylim = c(-5,15))
  #Set axis
  axis(1)
  axis(2)
  #Set title
  title(main = 'Spiral')
  #Draw segments in a spiral fashion with spiral functons
  text = spiral(start_position = c(0,15), direction = 0, length = 10, col)
  return(text)
}

# Question 28
tree <- function(start_position, direction, length, col){
  #Iterative function that calls itself twice; with directions that are 45 degrees
  #to the right and 45 degrees to the left. The length also decreases by a factor
  #of 0.65 each time the function calls itself.
  end = turtle(start_position, direction, length, col)
  if (length>0.01){
    tree(start_position = end, direction - pi/4 , length = 0.65*length, col)
    tree(start_position = end, direction + pi/4 , length = 0.65*length, col)
    }
}
draw_tree <- function(col = 'aquamarine')  {
  # clear any existing graphs and plot your graph within the R window
  graphics.off()
  plot.new()
  plot.window(xlim = c(0,10), ylim = c(0,10))
  axis(1)
  axis(2)
  title(main = 'Tree')
  tree(start_position = c(5,0), direction = pi/2, length = 3.5, col)
}

# Question 29
fern <- function(start_position, direction, length, col)  {
  #Iterative function that does the same thing as tree with different parameters
  #in order to draw a fern
  end = turtle(start_position, direction, length, col)
  if (length>0.02){
    fern(start_position = end, direction + pi/4 , length = 0.38*length, col)
    fern(start_position = end, direction , length = 0.87*length, col)
  }
}
draw_fern <- function(col = 'chocolate')  {
  # clear any existing graphs and plot your graph within the R window
  graphics.off()
  plot.new()
  plot.new()
  plot.window(xlim = c(-5,5), ylim = c(0,18))
  axis(1)
  axis(2)
  title(main = 'Fern')
  fern(start_position = c(0,0), direction = pi/2, length = 2, col)
}

# Question 30
fern2 <- function(start_position, direction, length, e, col, dir = 1)  {
  #Iterative function to draw a complete fern
  end = turtle(start_position, direction, length, col)
  #The complete fern is drown by adding a parameter that changes direction by a factor of -1
  #every time the function reaches a point were the segement is too small to be drown
  if (length>e){
    fern2(start_position = end, direction + dir*pi/6, length = 0.38*length, e, col, dir )
    fern2(start_position = end, direction , length = 0.87*length, e, col, dir*-1)
  }
}
draw_fern2 <- function(col = 'darkolivegreen')  {
  # clear any existing graphs and plot your graph within the R window
  graphics.off()
  plot.new()
  plot.window(xlim = c(-5,5), ylim = c(0,18))
  #Note that this fern is drown without axis.
  fern2(start_position = c(0,0), direction = pi/2, length = 2, col = col, e = 0.02)
}


# Challenge questions - these are optional, substantially harder, and a maximum of 16% is available for doing them.  

# Challenge question A
Challenge_A <- function(speciation_rate = 0.1, size = 100, n_sim = 100, 
                        duration = 36, rec = 3, conf = 0.972){
  #Plot mean species richness as a function of time (measured in generations) across a larage number of repeated
  #simulations
  # clear any existing graphs and plot your graph within the R window
  graphics.off()
  
  #Prealocating matrix of richnesses for different initial conditions; each column is one generation, and each row
  #is one simulation. Note that we don't record all the generations, so there are actually less columns than 
  #generations.
  #Note that we add 1 column to record the initial community richness
  richness_max = matrix(data = 0,  ncol = 1 + floor(duration/rec), nrow = n_sim)
  richness_min = matrix(data = 0,  ncol = 1 + floor(duration/rec), nrow = n_sim)
  #Initialite parameters
  sim = 1
  
  #Loop over simulations
  while (sim <= n_sim){
    #Calculate initial values of community and richness for each simulation
    community_max= init_community_max(size)
    community_min= init_community_min(size)
    richness_max[sim,1] = richness_max[sim,1] + species_richness(community_max)
    richness_min[sim,1] = richness_min[sim,1] + species_richness(community_min)
    #Loop over generations
    for (i in seq(duration)){
      #Evolve the communities one generation
      community_max = neutral_generation_speciation(community_max, speciation_rate)
      community_min = neutral_generation_speciation(community_min, speciation_rate)
      #Record richness if the generation is a multiple of rec
      if (i %% rec == 0) {
        #Assign richness for each simulation and generation
        richness_max[sim, i/rec+1] = richness_max[sim, i/rec+1] + 
          species_richness(community_max)
        richness_min[sim, i/rec+1] = richness_min[sim, i/rec+1] + 
          species_richness(community_min)
      }
    }
    sim = sim + 1
  }
  
  #Calculate 97.2 confidence intervals
  #Get quantile from normal distribution
  z = qnorm(conf, mean = 0, sd = 1)
  #Average over simulations and calculate errorbars
  mean_richness_max = colMeans(richness_max)
  err_max = apply(richness_max, 2, sd)*z/sqrt(nrow(richness_max))
  mean_richness_min = colMeans(richness_min)
  err_min = apply(richness_min, 2, sd)*z/sqrt(nrow(richness_min))
  
  #Prepare data for plotting
  mean_richness = cbind(t(mean_richness_max), t(mean_richness_min))
  err = cbind(t(err_max), t(err_min))
  init = c(rep('max',floor(duration/rec)+1), 
           rep('min',floor(duration/rec)+1))
  df = data.frame(gen = c(0,seq(rec,duration, rec)), 
                  mean_richness = t(mean_richness),
                  err = t(err), r_0 = init)
  
  #Plot
  plt = ggplot(data=df, aes(x = gen, y = mean_richness, fill = r_0)) +
    geom_bar(position = "identity", stat="identity") + #Bar plot
    geom_errorbar(aes(ymin=mean_richness-err, ymax=mean_richness+err), 
                  width = 0.5) + #Add errorbars
    theme(axis.title.x = element_text(size = 16, face = 'bold'),
          axis.title.y = element_text(size = 16, face = 'bold'),
          axis.text=element_text(size=14),
          axis.text.y = element_text(margin = margin(r = 0)),
          panel.grid.major = element_line(color = 'grey', size = 0.1), 
          panel.grid.minor = element_blank(), 
          panel.background = element_rect(fill = 'white'), 
          legend.position = c(0.3, 0.9), 
          legend.background = element_rect(fill=alpha('white', 0.4)), 
          legend.title=element_text(size=16),
          legend.text=element_text(size=16)) +
    scale_y_continuous(expand = c(0,0)) + #Get rid of margin in y scale
    scale_x_continuous(breaks = seq(0,36,6)) +
    labs( x="t (generations)", y = "mean species richness")
  
  #Show plot
  print(plt)
  
  return(cat('
             The stable state is reached when the richness from both initial conditions are the same
             This happens approximately at generation 33-36, where the 97.2
             confidence intervals for each initial condition overlap.
             '))
}

# Challenge question B
Challenge_B <- function(size = 100, speciation_rate = 0.1, duration = 36, n_sim = 20) {
  #Plot a grap showing many averaged time series for a whole range of different initial species richnesses.
  # clear any existing graphs and plot your graph within the R window
  graphics.off()
  
  #Initialite range of initial richnesses and prealocate matrix where averaged lines will be stored
  init_richness =seq(from = 10, to = size, by = 10)
  tot_lines = matrix(data = 0, nrow = duration + 1 , ncol = length(init_richness))
  #Loop over initial richnesses
  for (i in init_richness){
    sim = 1
    #Initialite the matrix of richness were each row is one generation and each column one simulation
    richness = matrix(data = 0, nrow = duration + 1 , ncol = n_sim)
    #Initialite community with a sequence of length = richness, to assure that we reach the dessired
    #richness, and complete the vector to reach te size of the community by dragging species id
    #contained already in the first part of the vector
    community = c(seq(i), sample(i, size-i, replace = T))
    #Run over simulations
    while (sim <= n_sim){
      #Calculate richness over a certain nuber of generations and assign to first row
      richness[,sim] = neutral_time_series_speciation(community = community, 
                                                    speciation_rate = speciation_rate, 
                                                    duration = duration)
      sim = sim + 1
    }
    #Average over simulations
    mean_richness = rowMeans(richness)
    #Assign to the first row of the averaged lines
    tot_lines[,i/10] = mean_richness

  }
  
  #Prepare data for plotting
  #In order to use the melt function we need the package reshape
  library(reshape)
  dat = melt(tot_lines)
  p = ggplot(data = dat, aes(x = X1, y = value, group = X2)) +
    geom_line(aes(color = X2)) +
    theme_bw() +
    theme(axis.title.x = element_text(size = 16),
          axis.title.y = element_text(size = 16),
          axis.text=element_text(size=14),
          axis.text.y = element_text(margin = margin(r = 0)),
          panel.grid.major = element_blank(), 
          panel.grid.minor = element_blank(), 
          panel.background = element_rect(fill = 'white'), 
          legend.position="none",
          plot.title = element_text(size = 20, face = 'bold')) +
    scale_y_continuous(breaks=seq(10,100,10)) +
    scale_x_continuous(expand = c(0, 0.01)) +
    scale_color_gradientn(colours = rainbow(11)) + #Set color gradient for each line
    labs(title = 'Averaged species richness\nfor different initial conditions', 
         x="t (generations)", y = "mean species richness")
  
  return(p)
}

Challenge_B_alternative <- function(size = 100, speciation_rate = 0.1, duration = 36) {
  #Plot a graph showing an averaged time series for a whole range of different initial species richnesses
  # clear any existing graphs and plot your graph within the R window
  graphics.off()
  
  #Initialize vector of initial richnesses
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
  #Average over simulations
  mean_richness = rowMeans(richness)
  
  #Prepare data for plotting
  x = rep(seq(dim(richness)[1]), dim(richness)[2] + 1)
  lines = c(as.numeric(matrix(richness)), mean_richness)
  group = rep((1:(dim(richness)[2]+1)), each = dim(richness)[1])
  color = c(rep('grey', length(richness)),rep('green', length(mean_richness)))
  size = c(rep(0.1, length(richness)),rep(0.7, length(mean_richness)))  
  df = data.frame(x = x, y = lines, color = color, size = size, group = group)
  
  #Plot
  p = ggplot(data = df, aes( x = x, y = y, group = group)) +
    geom_line(aes(color = color), size = size) +
    scale_color_manual(values=c("black", "grey"))+
    theme_bw() +
    theme(axis.title.x = element_text(size = 16, face = 'bold'),
          axis.title.y = element_text(size = 16, face = 'bold'),
          axis.text=element_text(size=14),
          axis.text.y = element_text(margin = margin(r = 0)),
          panel.grid.major = element_blank(), 
          panel.grid.minor = element_blank(), 
          panel.background = element_rect(fill = 'white'), 
          legend.position="none", 
          plot.title = element_text(size = 20, face = 'bold')) +
    scale_x_continuous(expand = c(0, 0.01)) +
    labs( title = 'Averaged species richness\nfor different initial conditions', 
          x="t (generations)", y = "species richness")
  
  #Show plot
  print(p)
  
  return(cat('
             An alternative understanding of the question yields this plot, in which many initial 
             conditions (grey lines) have been averaged to plot the black line
             '))
}

#Challenge C

#Auxiliary functions for Challenge_C
load_Challenge_C  = function(cut = 3500){
  #Load rda files and regturn a df ready to ggplot
  list_files = list.files('.', pattern = 'result_')
  #Preallocate richnes matrices
  richness_500 = matrix(data = 0, nrow = length(list_files)/4, ncol = 4001)
  richness_1000 = matrix(data = 0, nrow = length(list_files)/4, ncol = 8001)
  richness_2500 = matrix(data = 0, nrow = length(list_files)/4, ncol = 20001)
  richness_5000 = matrix(data = 0, nrow = length(list_files)/4, ncol = 40001)
  #Initialize counters for each size
  j = 1; k = 1; l = 1; m = 1
  #Create richness vector for each size by loading each file into the correct variable
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

  #Prepare data for plotting
  #Curves
  curves = c(richness_500_av, richness_1000_av, 
             richness_2500_av, richness_5000_av)
  #Assign a group to each size
  group = c(rep(0, length(richness_500_av)), rep(1, length(richness_1000_av)), 
            rep(2, length(richness_2500_av)), rep(3, length(richness_5000_av)))
  x = c(seq(length(richness_500_av)), seq(length(richness_1000_av)), 
        seq(length(richness_2500_av)), seq(length(richness_5000_av)))
  df = data.frame(x = x, curves = curves, group = group) 
  
  return(df)
}

fitting_Challenge_C = function(){
  #Fit each curve to a power law function
  #Note that the aim of performing fits to a model with an asimptote, is to establish a systematic and objective
  #method to determine when the stable state has been reached. The method to determine when the stable state
  #has been reched will be to set an arbitrarily close value to the asimptote of the model
  
  #Load loaded data with no cuts so we don't lose data in the fit, and it performs better
  df = load_Challenge_C(cut = 40000)
  
  #Separate by groups
  df_500 = subset(df, group == 0)
  df_1000 = subset(df, group == 1)
  df_2500 = subset(df, group == 2)
  df_5000 = subset(df, group == 3)
  
  #Perform fitting for each size
  #Avoid printing evaluation of fits in screen
  nls.control(printEval = F)
  fitmodel_500 <- nls(curves ~ a * (1 - 1/(x^b)) , #b Power law model with asimptote in a
                      data = df_500, #Data
                      start=list(a=11, b = 0.5)) #Starting values for parameters
  
  fitmodel_1000 = nls(curves ~ a * (1 - 1/(x^b)) ,
                      data = df_1000,
                      start=list(a=20, b=0.5))
  
  fitmodel_2500 = nls(curves ~ a * (1 - 1/(x^b)) ,
                      data = df_2500,
                      start=list(a=41, b=0.5))
  
  fitmodel_5000 = nls(curves ~ a * (1 - 1/(x^b)) ,
                      data = df_5000,
                      start=list(a=110, b=0.5))
  
  #Group models in one list for return
  models = list(fitmodel_500, fitmodel_1000, 
                fitmodel_2500, fitmodel_5000)
  
  return(models)
}

predictions = function(cut = 3500){
  #Get numerical values for fitted curves and prepare data for plotting
  
  #Get models
  models = fitting_Challenge_C()
  #Get prediction for curves
  curve_500 = predict(models[[1]])[1:cut]
  curve_1000 = predict(models[[2]])[1:cut]
  curve_2500 = predict(models[[3]])[1:cut]
  curve_5000 = predict(models[[4]])[1:cut]
  
  #Prepare data for plotting
  curves_pred = c(curve_500, curve_1000, curve_2500, curve_5000)
  x = c(seq(length(curve_500)), seq(length(curve_1000)), 
        seq(length(curve_2500)), seq(length(curve_5000)))
  group = c(rep(0, length(curve_500)), rep(1, length(curve_1000)), 
            rep(2, length(curve_2500)), rep(3, length(curve_5000)))
  df_pred = data.frame(x = x, y = curves_pred, group = group)
  
  return(df_pred)
}

stable_state = function(b, p = 0.89){
  #Returns the x value for a y value that is p*a. The dfault p value is 0.9
  #so we asssume stable state when the the value of the fitted curve is 90%
  #close to the assimptote
  return(1/(1-p)^(1/b))
}

# Challenge question C
Challenge_C <- function() {
  # clear any existing graphs and plot your graph within the R window
  graphics.off()
  
  #Load loaded data, ready for plotting
  df = load_Challenge_C()
  
  #Load model predictions ready for plotting
  df_pred = predictions()
  
  # #To determine where do they reach stable state, we impose that the y value must be
  # #0.9*a, with a being the value of the asymptote of the function 
  # #f(x) = a * (1 - 1/(x)^b)
  
  #Determine stable states coordinates
  models = fitting_Challenge_C()
  b = c()
  for (i in seq(length(models))){
    b = c(b,as.numeric(coef(models[[i]]))[2])
  }
  
  vlines = rev(stable_state(b))
  
  #Prepare data for plot
  df_lines = data.frame(vlines = vlines, 
                        color = rainbow(4))
  
  #Plot
  p = ggplot(data = df, aes(x = x, y = curves, group = group, 
                            color = as.factor(group))) +
    geom_line() + #Add simulations
    geom_line(data = df_pred, aes(x = x, y = y, group = group), color= 'black',
              show.legend = F) + #Add fitted lines
    geom_vline(aes(xintercept = vlines), #Add vertical lines to mark stable states
               color = rainbow(4),
               linetype = "dashed",
               size = 0.7,
               data = df_lines,
               show.legend = F) + #Not show in the legend
    geom_segment(aes(x = 1900, y = 108.4, xend = 1900, yend = 100), #Add arrow to plot
                 color = 'black',
                 size = 0.1,
                 arrow = arrow(length = unit(0.2,"cm"), type = "closed"),
                 show.legend = F, #Not show in legend
                 inherit.aes = F) + #Avoid inherit aesthetics from plot
    theme_bw() + 
    theme(
      plot.title = element_text(size = 20, face = 'bold'), 
      axis.title.x = element_text(size = 16),
      axis.title.y = element_text(size = 16),
      axis.text=element_text(size=14),
      axis.text.y = element_text(margin = margin(r = 0)),
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank(),
      panel.background = element_rect(fill = 'white'),
      legend.position = c(0.3, 0.7), 
      legend.title = element_text(size = 18), 
      legend.key = element_rect(colour = NA, fill = NA), #Transparent background for the keys of legend
      legend.text=element_text(size=14),
      legend.key.size = unit(2,"line"),
      legend.background = element_rect(fill = "transparent")) + #No background for legend
    scale_y_continuous(expand = c(0,0)) +
    scale_color_manual(name = "",
                       values = rainbow(4),
                       labels = c("L = 500", "L = 1000", 
                                  "L = 2500", "L = 5000")) +
    labs(title = 'Averaged species richness\nfor different sizes',
         x="t (generations)", y = "mean species richness") +
    #Add annotations to show the stable time explicitly
    annotate('text', x=550, y=7, label = "paste(italic(t) [stable], \" = 366\")", 
             parse = TRUE, fontface="bold", size = 5, 
             hjust = 0) +
    annotate('text', x=550, y=16, label = "paste(t [stable], \" = 473\")",
             parse = TRUE, fontface="bold", size = 5 ,
             hjust = 0) +
    annotate('text', x=1400, y=50, label ="paste(italic(t) [stable], \" = 1333\")",
             parse = TRUE, fontface="bold", size = 5 ,
             hjust = 0) +
    annotate('text', x=2500, y=103, label = "paste(italic(t) [stable], \" = 2440\")",
             parse = TRUE, fontface="bold", size = 5 ,
             hjust = 0) +
    #Add equation for fitted models
    annotate('text', x = 1900, y = 95, 
             label = 'f(t)==a~bgroup("(",1-frac(1,1-x^{-b}),")")', 
             size = 5,
             parse = T)
  
  
  return(p)
}
#Challenge question D
Challenge_D <- function() {
  
  #Get current time
  cluster_ptm <- proc.time()
  
  # run the cluster results first so that we can get rid of the graphs before plotting them all together
  #a list of four vectors will be stored in 'means'
  means = process_cluster_results() #
  
  # calculate the cluster time
  cluster_time = proc.time() - cluster_ptm
  
  coalescence_ptm <- proc.time()
  
  # clear any existing graphs and plot your graph within the R window
  graphics.off() 
  
  speciation_rate = 0.1
  
  # a list containing the size, initial community, and abundance vector of the 4 community sizes 
  #(500, 1000, 2500, 5000)
  community = list(500, lineages_500 = init_community_min(500), abundances_500 = vector(),
                   1000, lineages_1000 = init_community_min(1000), abundances_1000 = vector(),
                   2500, lineages_2500 = init_community_min(2500), abundances_2500 = vector(),
                   5000, lineages_5000 = init_community_min(5000), abundances_5000 = vector())
  
  intervals = seq(1, 12, by = 3)
  
  # run the pseudo code for each community size
  for(n in intervals){
    N = community[[n]]
    theta = speciation_rate * ((N - 1) / (1 - speciation_rate))
    
    while(N > 1) {
      # randmomly choose an index of the lineages vector
      j = sample(N, size = 1, replace = FALSE, prob = NULL)
      # choose a random number between 0 and 1
      randnum = runif(n = 1, min = 0, max = 1) 
      
      if(randnum < (theta)/(theta+N-1)) {
        # appends the value at index j to the abundances vector
        community[[n+2]] = c(community[[n+2]], community[[n+1]][j]) 
      } else {
        i = sample(N, size = 1, replace = FALSE, prob = NULL)
        
        while(i == j )
          # makes sure the new index chosen is different than j
          i = sample(N, size = 1, replace = FALSE, prob = NULL) 
        
        # adds the value at index j to the value at index i
        community[[n+1]][i] = community[[n+1]][i] + community[[n+1]][j]
      }
      
      # reduces the lineages vector by 1
      community[[n+1]] = community[[n+1]][-j] 
      # reduces the community size by 1
      N = N - 1 
    }
    
    # adds the remaining element in the lineages vector to the abundances vector
    community[[n+2]] = c(community[[n+2]], community[[n+1]]) 
  }
  
  # calculate the coalescence time
  coalescence_time = proc.time() - coalescence_ptm
  
  # calculate the octaves using the species abundances for each community size
  o_500 = octaves(sort(community$abundances_500, decreasing = TRUE))
  o_1000 = octaves(sort(community$abundances_1000, decreasing = TRUE))
  o_2500 = octaves(sort(community$abundances_2500, decreasing = TRUE))
  o_5000 = octaves(sort(community$abundances_5000, decreasing = TRUE))
  
  #Prepare data for plotting
  df_500 = data.frame(x = seq(length(o_500)), av_oct = o_500)
  df_1000 = data.frame(x = seq(length(o_1000)), av_oct = o_1000)
  df_2500 = data.frame(x = seq(length(o_2500)), av_oct = o_2500)
  df_5000 = data.frame(x = seq(length(o_5000)), av_oct = o_5000)
  
  #Plot
  o_500  <- ggplot(data=df_500, aes(x, y=av_oct)) +
    geom_bar(stat="identity", fill = '#A35638')+
    theme_minimal()+
    theme(panel.grid.major = element_blank(), 
          panel.grid.minor = element_blank(),
          axis.text=element_text(size=12)) + 
    
    scale_x_continuous(breaks = c(0.5,1.5,2.5,3.5,4.5,5.5,6.5,7.5,8.5,9.5 ), 
                       labels = c(0,1,2,3,4,5,6,7,8,9)) +
    annotate("text", x=3, y = Inf, vjust=1, hjust='center', #Label each plot
             label = "L = 500", size = 5) +
    labs(title = NULL, x = NULL, y = NULL)
  
  o_1000  <- ggplot(data=df_1000, aes(x, y=av_oct)) +
    geom_bar(stat="identity", fill = '#E08f62')+
    theme_minimal()+
    theme(panel.grid.major = element_blank(), 
          panel.grid.minor = element_blank(),
          axis.text=element_text(size=12)) + 
    labs(title = NULL, x = NULL, y = NULL) +
    scale_x_continuous(breaks = c(0.5,1.5,2.5,3.5,4.5,5.5,6.5,7.5,8.5,9.5,10.5), 
                       labels = c(0,1,2,3,4,5,6,7,8,9,10))+
    annotate("text", x=3, y = Inf, vjust=1, hjust='center',
             label = "L = 1000", size = 5)
  
  o_2500  <- ggplot(data=df_2500, aes(x, y=av_oct)) +
    geom_bar(stat="identity", fill = '#D7C79E')+
    theme_minimal()+
    theme(panel.grid.major = element_blank(), 
          panel.grid.minor = element_blank(),
          axis.text=element_text(size=12)) + 
    labs(title = NULL, x = NULL, y = NULL) +
    scale_x_continuous(breaks = c(0.5,1.5,2.5,3.5,4.5,5.5,6.5,7.5,8.5,9.5,10.5,11.5 ), 
                       labels = c(0,1,2,3,4,5,6,7,8,9,10,11))+
    annotate("text", x=3, y = Inf, vjust=1, hjust='center',
             label = "L = 2500", size = 5)
  
  o_5000  <- ggplot(data=df_5000, aes(x, y=av_oct)) +
    geom_bar(stat="identity", fill = '#9DAB86')+
    theme_minimal()+
    theme(panel.grid.major = element_blank(), 
          panel.grid.minor = element_blank(),
          axis.text=element_text(size=12)) + 
    labs(title = NULL, x = NULL, y = NULL) +
    scale_x_continuous(breaks = c(0.5,1.5,2.5,3.5,4.5,5.5,6.5,7.5,8.5,9.5,10.5,11.5,12.5 ), 
                       labels = c(0,1,2,3,4,5,6,7,8,9, 10, 11,12))+
    annotate("text",x=3, y = Inf, vjust=1, hjust='center',
             label = "L = 5000", size = 5)
  
  #Now from coalescence
  #Prepare data for plot
  df_500_means = data.frame(x = seq(length(means[[1]])), av_oct = means[[1]])
  df_1000_means = data.frame(x = seq(length(means[[2]])), av_oct = means[[2]])
  df_2500_means = data.frame(x = seq(length(means[[3]])), av_oct = means[[3]])
  df_5000_means = data.frame(x = seq(length(means[[4]])), av_oct = means[[4]])
  
  #Plot
  o_500_mean  <- ggplot(data=df_500_means, aes(x, y=av_oct)) +
    geom_bar(stat="identity", fill = '#A35638')+
    theme_minimal()+
    theme(panel.grid.major = element_blank(), 
          panel.grid.minor = element_blank(),
          axis.text=element_text(size=12)) + 
    labs(title = NULL, x = NULL, y = NULL) +
    scale_x_continuous(breaks = c(0.5,1.5,2.5,3.5,4.5,5.5,6.5,7.5,8.5,9.5 ), 
                       labels = c(0,1,2,3,4,5,6,7,8,9)) +
    annotate("text", x=4.5, y = Inf, vjust=1, hjust='center', 
             label = "L = 500", size = 5)
  
  o_1000_mean  <- ggplot(data=df_1000_means, aes(x, y=av_oct)) +
    geom_bar(stat="identity", fill = '#E08f62')+
    theme_minimal()+
    theme(panel.grid.major = element_blank(), 
          panel.grid.minor = element_blank(),
          axis.text=element_text(size=12)) + 
    labs(title = NULL, x = NULL, y = NULL) +
    scale_x_continuous(breaks = c(0.5,1.5,2.5,3.5,4.5,5.5,6.5,7.5,8.5,9.5,10.5), 
                       labels = c(0,1,2,3,4,5,6,7,8,9,10))+
    annotate("text", x=5, y = Inf, vjust=1, hjust='center',
             label = "L = 1000", size = 5)
  
  o_2500_mean  <- ggplot(data=df_2500_means, aes(x, y=av_oct)) +
    geom_bar(stat="identity", fill = '#D7C79E')+
    theme_minimal()+
    theme(panel.grid.major = element_blank(), 
          panel.grid.minor = element_blank(),
          axis.text=element_text(size=12)) + 
    labs(title = NULL, x = NULL, y = NULL) +
    scale_x_continuous(breaks = c(0.5,1.5,2.5,3.5,4.5,5.5,6.5,7.5,8.5,9.5,10.5,11.5 ), 
                       labels = c(0,1,2,3,4,5,6,7,8,9,10,11))+
    annotate("text", x=5.5, y = Inf, vjust=1, hjust='center',
             label = "L = 2500", size = 5)
  
  o_5000_mean  <- ggplot(data=df_5000_means, aes(x, y=av_oct)) +
    geom_bar(stat="identity", fill = '#9DAB86')+
    theme_minimal()+
    theme(panel.grid.major = element_blank(), 
          panel.grid.minor = element_blank(),
          axis.text=element_text(size=12)) + 
    labs(title = NULL, x = NULL, y = NULL) +
    scale_x_continuous(breaks = c(0.5,1.5,2.5,3.5,4.5,5.5,6.5,7.5,8.5,9.5,10.5,11.5,12.5 ), 
                       labels = c(0,1,2,3,4,5,6,7,8,9, 10, 11,12))+
    annotate("text",x=6, y = Inf, vjust=1, hjust='center',
             label = "L = 5000", size = 5)
  
  #Join all plots into a single panel
  figure <- ggarrange(o_500, o_500_mean, o_1000, o_1000_mean,
                      o_2500, o_2500_mean,o_5000, o_5000_mean,
                      labels = NULL,
                      ncol = 2, nrow = 4)
  #Write common title and axis for all plots
  figure <- annotate_figure(figure, top = text_grob("Coalescence                                   Cluster Simulations", 
                                                    color = "black", face = "bold", size = 18), 
                            left = text_grob(label = "Richness", color = 'black', face = 'bold', size = 16, rot = 90), 
                            bottom = text_grob(label = "n", 
                                               color = 'black', face = 'bold', size = 16))
  
  #Show plot
  print(figure)
  
  #Time analysis
  cluster = as.numeric(cluster_time[3])
  coalescence = as.numeric(coalescence_time[3])
  factor = cluster/coalescence
  
  return(paste0("The coalescence simulations takes ", format(round(coalescence,3)), " seconds, and the cluster takes ", format(round(cluster,3)), 
               " seconds. The coalescence method is faster by a factor of ", format(round(factor)), 
               ". The reason for this is that coalescence does not include situations where species go extinct, which increases computation time, since it goes backwards in time.", collapse = ""))
}

# Challenge question E

#Auxiliary functions for challenge E
calc = function(init_points, it = 10000, zero = init_points[1,], scale = 0.5){
  #Calculates the points based on the initial points and the rule of traveling
  #a certain fraction to one of them.
  #Prealocate matrix of points to be calculated
  points = matrix(c(zero, rep(0,2*it-2)), nrow = it, ncol = 2, byrow = T)
  for (i in seq(it-1)){
    #Choose a point
    ind = sample(seq(dim(init_points)[1]),1)
    #Calculate coordinates of next point based on the half distance rule
    points[i+1,] = scale * (points[i,] + init_points[ind,])
  }
  return(points)
}

Challenge_E <- function(it = 300000, init) {
  # clear any existing graphs and plot your graph within the R window
  graphics.off()
  
  #Diferent examples based on calc function are ploted below
  #################################################################################

  #Away from the triangle
  ini = c(0,3,4,0,4,1)
  init_points = matrix(ini, nrow = length(ini)/2, ncol = 2)
  points = calc(init_points, zero = c(-3,-3), it = 5000)
  
  #Prepare data for plot
  df_init = data.frame(init_points)
  df_points = data.frame(points, color = c(rep(0, 5), rep(1, dim(points)[1]-5))) 
  
  #Plot
  p = ggplot(df_init, aes(X1, X2)) + 
    geom_point(color = 'red', size = 4, shape = 25, fill = 'darkolivegreen') +
    geom_point(data = df_points, aes(X1, X2, color = as.factor(color), 
                                     size = as.factor(color)))+
    scale_size_manual(values=c(3,1))+
    scale_color_manual(values=c('black','#003cb4'))+
    theme_minimal()+
    theme(legend.position = 'none', plot.title = element_text(size = 18),
          axis.title.x = element_blank(), axis.title.y = element_blank() , 
          panel.grid.major = element_blank(), panel.grid.minor = element_blank(), 
          axis.text.x = element_blank(), axis.text.y = element_blank()) +
    annotate("text",x=1, y = Inf, vjust=0.9, hjust='center',
             label = "Displaced initial points", size = 5)

  #################################################################################
  
  #Equilateral triangle
  init_points = matrix(c(0,0,1,0,0.5,sqrt(3)/2), byrow = T, ncol = 2)
  points = calc(init_points, it = 5000)
  
  #Prepare data for plot
  df_init = data.frame(init_points)
  df_points = data.frame(points) 
  
  #Plot
  q = ggplot(df_init, aes(X1, X2)) + 
    geom_point(color = 'red', size = 4, shape = 25, fill = 'darkolivegreen') +
    geom_point(data = df_points, aes(X1, X2), size = 0.2, color ='mediumspringgreen')+
    theme_minimal()+
    theme(legend.position = 'none', plot.title = element_text(size = 18),
          axis.title.x = element_blank(), axis.title.y = element_blank() , 
          panel.grid.major = element_blank(), panel.grid.minor = element_blank(), 
          axis.text.x = element_blank(), axis.text.y = element_blank()) + 
    annotate("text",x=0.5, y = Inf, vjust=0.9, hjust='center',
             label = "Sierpinski Gasket", size = 5)
  
  #################################################################################
  
  #Different scale
  init_points = matrix(c(0,0,1,0,0.5,sqrt(3)/2), byrow = T, ncol = 2)
  points = calc(init_points, scale = 0.4, it = 3000)
  
  #Prepare data for plot
  df_init = data.frame(init_points)
  df_points = data.frame(points) 
  
  #Plot
  r = ggplot(df_init, aes(X1, X2)) + 
    geom_point(color = 'red', size = 4, shape = 25, fill = 'darkolivegreen') +
    geom_point(data = df_points, aes(X1, X2), size = 0.2, color ='lightseagreen')+
    theme_minimal()+
    theme(legend.position = 'none', plot.title = element_text(size = 18),
          axis.title.x = element_blank(), axis.title.y = element_blank() , 
          panel.grid.major = element_blank(), panel.grid.minor = element_blank(), 
          axis.text.x = element_blank(), axis.text.y = element_blank()) + 
    annotate("text",x=0.5, y = Inf, vjust=.9, hjust='center',
             label = "Different scale", size = 5)
  
  #################################################################################
  
  #Square
  init_points = matrix(c(0,0,1,0,0,1, 1,1), byrow = T, ncol = 2)
  points = calc(init_points, it = 20000)
  
  #Prepare data for plot
  df_init = data.frame(init_points)
  df_points = data.frame(points) 
  
  #Plot
  s = ggplot(df_init, aes(X1, X2)) + 
    geom_point(color = 'red', size = 4, shape = 25, fill = 'darkolivegreen') +
    geom_point(data = df_points, aes(X1, X2), size = 0.2, color ='#351223')+
    theme_minimal()+
    theme(legend.position = 'none', plot.title = element_text(size = 18),
          axis.title.x = element_blank(), axis.title.y = element_blank() , 
          panel.grid.major = element_blank(), panel.grid.minor = element_blank(), 
          axis.text.x = element_blank(), axis.text.y = element_blank()) +
    annotate("text",x=0.5, y = Inf, vjust=.9, hjust='center',
             label = "Square", size = 5)

  #################################################################################
  
  #Pentagone
  init_points = matrix(c(0,650,95,581,59,469,-59,469,-95,581), byrow = T, ncol = 2)
  points = calc(init_points, it = 200000)
  
  #Prepare data for plot
  df_init = data.frame(init_points)
  df_points = data.frame(points) 
  
  #Plot
  t = ggplot(df_init, aes(X1, X2)) + 
    geom_point(color = 'red', size = 4, shape = 25, fill = 'darkolivegreen') +
    geom_point(data = df_points, aes(X1, X2), size = 0.2, color ='#123524')+
    theme_minimal()+
    theme(legend.position = 'none', plot.title = element_text(size = 18),
          axis.title.x = element_blank(), axis.title.y = element_blank() , 
          panel.grid.major = element_blank(), panel.grid.minor = element_blank(), 
          axis.text.x = element_blank(), axis.text.y = element_blank()) +
    annotate("text",x=0, y = Inf, vjust=0.9, hjust='center',
             label = "Pentagon", size = 5)
  
  #################################################################################
  
  #Hexagone
  ini= c(0,650,87,600,87,500,0,450,-87,500,-87,600)
  init_points = matrix(ini, byrow = T, ncol = 2)
  points = calc(init_points, it = 60000)
  
  #Prepare data for plot
  df_init = data.frame(init_points)
  df_points = data.frame(points) 
  
  #Plot
  u = ggplot(df_init, aes(X1, X2)) + 
    geom_point(color = 'red', size = 4, shape = 25, fill = 'darkolivegreen') +
    geom_point(data = df_points, aes(X1, X2), size = 0.05, color ='#b47800')+
    theme_minimal()+
    theme(legend.position = 'none', plot.title = element_text(size = 18),
          axis.title.x = element_blank(), axis.title.y = element_blank() , 
          panel.grid.major = element_blank(), panel.grid.minor = element_blank(), 
          axis.text.x = element_blank(), axis.text.y = element_blank()) +
    annotate("text",x=0, y = Inf, vjust=0.8, hjust='center',
             label = "Hexagon", size = 5)
  
  ##################################################################################
  
  #Merge all plots together in one panel
  figure <- ggarrange(p, q, r, s, t, u, 
                      labels = NULL,
                      ncol = 3, nrow = 2)
  
  figure <- annotate_figure(figure,
                            top = text_grob("Possibilities of Chaos Game",
                                            face = "bold", size = 18))
  
  #Show plot
  print(figure)

  return("In the beginning, points lay in forbidden areas, but after a number of iterations, they travel back to their normal domain. The points end up being constrained between the initial points because we are imposing that every iteration you get a set fraction closer to one of the initial points.")
}

# Challenge question F

# Auxiliary functions for question F
fern2_col <- function(start_position, direction, length, e, dir = 1)  {
  #Function to produce a fern with different colors depending on the level of ramification

  if (length > 5*e){
    end = turtle(start_position, direction, length, col = 'olivedrab4')
  }
  else{
    end = turtle(start_position, direction, length, col = '#b47800')
  }
  #The complete fern is drown by adding a parameter that changes direction by a factor of -1
  #every time the function reaches a point were the segement is too small to be drown
  if (length > e){
    fern2_col(start_position = end, direction + dir*pi/6, length = 0.38*length, e, dir)
    fern2_col(start_position = end, direction , length = 0.87*length, e, dir*-1)
  }
}

Challenge_F <- function() {
  # clear any existing graphs and plot your graph within the R window
  graphics.off()
  
  #Get plots for several lengths
  #Initialize lengths, number of simulations and time vector
  it = seq(0.1, 0.02, length.out = 10)
  nsim = 10
  time.vec = matrix(data = 0, nrow = nsim, ncol = length(it) )
  #Loop over the simulations
  for (i in seq(nrow(time.vec))){
    #Loop over the different lengths e
    for (j in seq(ncol(time.vec))){
      plot.new()
      plot.window(xlim=c(-5,5), ylim=c(0,18))
      #Calculate time for the current length
      start = Sys.time()
      fern2(start_position = c(0,0), direction = pi/2, length = 2, e  = it[j],
            col = 'darkolivegreen')
      end = Sys.time()
      #Store in the time matrix
      time.vec[i,j] = as.numeric(end-start)
    }
  }
  
  #Prepare layout of the plots
  layout(matrix(c(1,1,2,3,4,5), 2, 3, byrow = TRUE), 
         widths=c(1,1,1), heights=c(1,1))
  
  #Calculate median across simulations.
  #Note that we calculate the median and not the mean because it is more robust, and the presence
  #of significant outliers make it a better choice.
  median.time = apply(time.vec, 2, median)
  
  #Plot
  x = rep(it, each = nrow(time.vec))
  #Plot time analysis
  plot(x, as.vector(time.vec), 
       col = rgb(red = .16, green = 0.160, blue = 0.160, alpha = 0.5), 
       cex = 0.7, pch = 19,
       xlab = 'Line size threshold', ylab = 'time (s)', 
       ylim = c(0, 0.45), xlim = rev(range(x)))
  points(it, median.time, pch = 19, col = 'red')
  legend('topleft', legend=c("Simulations", "Median"),
         col=c("grey", "red"), pch = 19, cex = 1)
  #Plot cool fern
  plot.new()
  plot.window(xlim = c(-5,5), ylim = c(0,18))
  title(main = 'e = 0.003')
  fern2_col(start_position = c(0,0), direction = pi/2, length = 2, e = 0.003)
  #Select different lengths
  plot_lengths = c(it[1], it[round(length(it)/2)], it[length(it)])
  #Plot ferns for diferent lengths
  for (i in plot_lengths){
    plot.new()
    plot.window(xlim = c(-5,5), ylim = c(0,18))
    title(main = paste('e = ', round(i, digits = 2)), cex = 1.5)
    fern2(start_position = c(0,0), direction = pi/2, length = 2, e = i, col = 'darkolivegreen')
  }
  
  return("The image produced is more ramified the smaller the line size threshold is. However, computational time also increases as seen in the first graph.")
}
# Challenge question G should be written in a separate file that has no dependencies on any functions here.


