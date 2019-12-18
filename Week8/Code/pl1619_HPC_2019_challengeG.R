# CMEE 2019 HPC excercises R code challenge G proforma

rm(list=ls()) # nothing written elsewhere should be needed to make this work

name <- "Pablo Lechon"
email <- "plechon@ucm.es"
username <- "pl1619"

# don't worry about comments for this challenge - the number of characters used will be counted starting from here

f=function(a,b,d,l,e,o=1){
z=l*cos(d)+a
w=l*sin(d)+b
segments(a,b,z,w)
if(l>e){
f(a=z,b=w,d+o*pi/6,l=0.38*l,e,o)
f(a=z,b=w,d,l=0.87*l,e,o*-1)
}
}
d=function(){
plot.new()
plot.window(xlim=c(-5,5),ylim=c(0,18))
f(a=0,b=0,d=pi/2,l=2,e=0.02)
}
d()