setwd('/Users/pablolechon/Desktop/Imperial/CMEECourseWork/Week5/Code/')
rm(list = ls())
library(plyr)

d = read.csv('../Data/dessert.txt')


#With DM
ddm = subset(d, d$species=='DM')
ddmf = subset(ddm, ddm$sex == 'F')
ddmm = subset(ddm, ddm$sex == 'M')

#Removing repeated values
ddmf = dplyr::distinct(ddmf, tag = ddmf$tag, .keep_all = T)
ddmm = dplyr::distinct(ddmm, tag = ddmm$tag, .keep_all = T)

#Rewriting months
#ddmf
for (i in seq(length(ddmf$mo))){
  if (nchar(as.character(ddmf$mo[i])) == 1){
    ddmf$mo[i] = paste(0,ddmf$mo[i], sep = '')
  }
  else{
    ddmf$mo[i] = as.character(ddmf$mo[i])
  }
}

#ddmm
#ddmf
for (i in seq(length(ddmm$mo))){
  if (nchar(as.character(ddmm$mo[i])) == 1){
    ddmm$mo[i] = paste(0,ddmm$mo[i], sep = '')
  }
  else{
    ddmm$mo[i] = as.character(ddmm$mo[i])
  }
}

#Calculating the mean per month
ddmf$date = paste(ddmf$yr, ddmf$mo, sep = '')
ddmm$date = paste(ddmm$yr, ddmf$mo, sep = '')

#Converting date column to a number
ddmf$date = sapply(ddmf$date,  as.numeric)
ddmm$date = sapply(ddmm$date,  as.numeric)

dplyr::tbl_df(ddmf);dplyr::tbl_df(ddmm)



table_ddmf = ddply(ddmf, .(date), summarize,
      mean_wgt = mean(wgt, na.rm = T),
      mean_precip = mean(precip, na.rm = T))

table_ddmm = ddply(ddmm, .(date), summarize,
                   mean_wgt = mean(wgt, na.rm = T),
                   mean_precip = mean(precip, na.rm = T))
#Plots
plot(seq(length(table_ddmf$mean_precip)), table_ddmf$mean_precip,
     type = 'l',lty = 1, col = 'blue', 
     xlab = 'Time')
lines(seq(length(table_ddmf$mean_precip)), table_ddmf$mean_wgt, 
      type = 'l',lty = 1, col = 'red', yaxt='n', ann=FALSE)
