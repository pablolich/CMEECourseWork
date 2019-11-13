setwd("/Users/pablolechon/Desktop/Imperial/CMEECourseWork/Week6/Code/")
lep<-read.csv("../Data/leopard_gecko.csv", header=FALSE, stringsAsFactors=FALSE, colClasses=rep("character", 20000))
ben<- read.csv("../Data/bent-toed_gecko.csv", header=FALSE, stringsAsFactors=FALSE, colClasses=rep("character", 20000))
wes<- read.csv("../Data/western_banded_gecko.csv", header=FALSE, stringsAsFactors=FALSE, colClasses=rep("character", 20000))

#So its easier to manage
#small = lep[1:4, 1:20]
#Wiggle it so it actually gives something back
#small[4,4] = 'T'
#small[2,5] = 'G'
#lep = small
#Compare pairs of rows to find which pairs are diferent 
j = 1
polymorphism_remover <- function(data) {
  m = matrix(data = T, nrow = nrow(data), ncol = ncol(data))
  for (i in seq(1, nrow(data)-1)){
    m[j,]=data[i,]==data[i+1,]
    j = j + 1
  }
  #If the element of one column is false, then the elements of 
  new = !logical(length = ncol(m))
  for (i in seq(nrow(m))){
    new = new & m[i,]
  }
  
  return(new)
}


  {#create a list of dataframes
  tot = list(lep, ben, wes)
  #prealocate the vectors of snips
  news = matrix(NA, length(tot), ncol(lep))
  #generate vector of snips
  for (i in (seq(length(tot)))){
    news[i,] = polymorphism_remover(tot[[i]])
  }}

conb_mat = combn(seq(dim(news)[1]), 2)
div_vect
for (i in seq(dim(conb_mat)[2])){
  
}
#Calculate divergences

#Calculate divergences between species (#FALSE/#TRUE)
#Create pairs
div1 = news[1,] & news[2,]
div1_real = (length(div1)-sum(div1))/sum(div1)
div2 = news[1,] & news[3,]
div2_real = (length(div2)-sum(div2))/sum(div2)
div3 = news[2,] & news[3,]
div3_real = (length(div3)-sum(div3))/sum(div3)
div_max = max(c(div1_real, div2_real, div3_real))

#Pick the largest one to calculate the mutation rate
t = 30e7
mu = div_max/(2*t)
#Pick the shortest one to calculate the divergence time.
t1 = div1_real/(2*mu)
t2 = div2_real/(2*mu)
t3 = div3_real/(2*mu)