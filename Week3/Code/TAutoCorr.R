########################################################################################
##VISUALICING DATA##
########################################################################################

rm(list = ls())
setwd(paste("~/Desktop/Imperial/CMEECourseWork/Week3/Code/", sep = ''))
load('../Data/KeyWestAnnualMeanTemperature.RData', envir = globalenv())

par(mfrow = (c(1,1)))
#Create a function to generate a continuous color palette
rbPal <- colorRampPalette(c('blue','red'))

#Add a column with the value of the color depending on the y value
#Explanation of what this is doing:
#First, we generate 'diffuminate' colors that go progressively from blue to red.
diffuminate = 100
colors_palette = rbPal(diffuminate)
#Of those 'diffuminate' colors, we pick the ones that match our data. Of course, we
#have to map our data to a 'diffuminate' color basis. We do this with the command cut
#which divides the data into 'diffuminate' subgroups. Finally, we transform those groups
#or factors into numbers with as.numeric
mapping = as.numeric(cut(ats$Temp,breaks = diffuminate))
#Finally, we select from the pallette of colors those that our y values demand.
colors_plot = colors_palette[mapping]
#Create a column with this color values
ats$Col = colors_plot
plot(ats$Year, ats$Temp, main = 'Temperature evolution', #Draw points
     pch = 16, lwd = 0.5, cex = 0.7, col = ats$Col,
     xlab = 'Year', ylab = 'Temperature (ºC)')

#Add line

points(ats$Year, ats$Temp, type = 'l', lty = 3) #Add dotted line to follow tendency

#Add dashed horizontal line indicating the mean

mean = mean(ats$Temp)
#Adding dotted line at the mean value
abline(h = mean, col = 'black', lwd = 1, lty = 'dashed') 

#Add legend to the plot

legend(1960, 24.12, legend='Mean temperature',
       col='black', lty='dashed', cex=0.8, 
       box.col = 'white', box.lty = 'dotdash') #Formatting the legend box


########################################################################################
##CALULATING CORRELATION COEFFICIENT BETWEEN SUCCESIVE YEARS##
########################################################################################

#Create 2 lists of years shifted 1 year with respect each other
year1 = ats$Temp[-1]
year2 = ats$Temp[-length(ats$Temp)]

#Correlation coefficient
corr = cor(year1, year2)

#Check wether this correlation is significant or not
#Generate a matrix of correlations if our temperatures were randomly distributed
n_simulations = 10000
X = matrix(NA, length(ats$Temp), n_simulations)
for (i in seq(n_simulations)){
  #Each column of the matrix is substituted by a random order of temperatures.
  X[,i] = sample(ats$Temp)
}

#Calculate the matrix of correlations
cor_matrix = cor(X)

#The correlations between consecutive years is located at indexes of the form (i, i+1)
#or (i+1, i), since the matrix is symmetric

cor_consecutive_years = cor_matrix[col(cor_matrix) == row(cor_matrix) + 1]
h1 = hist(cor_consecutive_years, main = 'Random correlations',
          xlab = 'Correlation',
          breaks = seq(-0.4, 0.4, 0.05))
abline(v = corr, col = 'red', type = 'l', lty = 'dashed')

#To calculate the p-value we calculate what fraction of the correlation 
#coefficients from the previous step were greater than that from step 1

p_value = sum(cor_consecutive_years > corr)/n_simulations
