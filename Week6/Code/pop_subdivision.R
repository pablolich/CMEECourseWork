setwd('~/Desktop/Imperial/CMEECourseWork/Week6/Code/')
#Load data
alleles = read.csv('../Data/turtle.csv', header = F)
genotypes = read.csv('../Data/turtle.genotypes.csv')
#get the frequencies 
freq_vec1 = c()
for (i in seq(ncol(alleles))){
  freq_vec1[i] = sum(alleles[1:20,i])/20
}

freq_vec2 = c()
for (i in seq(ncol(alleles))){
  freq_vec2[i] = sum(alleles[21:40,i])/20
}

freq_vec3 = c()
for (i in seq(ncol(alleles))){
  freq_vec3[i] = sum(alleles[41:60,i])/20
}

freq_vec4 = c()
for (i in seq(ncol(alleles))){
  freq_vec4[i] = sum(alleles[61:80,i])/20
}

#Do the pairwise comparison
l = list(freq_vec1, freq_vec2, freq_vec3, freq_vec4)
lhs = list()
lht = list()
lfst = list()
k = 1
for (i in seq(4)){
  for (j in seq(4)){
    if (i<j){
      lhs[[k]] = mean((2*l[[i]]*(1-l[[i]]) + 2*l[[j]]*(1-l[[j]]))/2)
      lht[[k]] = mean((l[[i]]+l[[j]])*(1-(l[[i]]+l[[j]])/2))
      lfst[[k]] = (lht[[k]] - lhs[[k]])/lht[[k]] 
      k = k + 1
    }
  }
}


