#!/bin/bash 

if [ -z $1 ]
then echo "Provide a document to compile!"
     exit
fi

pdflatex $1.tex
bibtex $1
pdflatex $1.tex
pdflatex $1.tex

## Cleanup
#First,we send all the new created files to the folder compile. Then we find
#all the files in our current directory that don't have the 
#extension .tex and .pdf. We have to specify that we want to find only files
#otherwise we will also get the hidden directories. Once we have them
#we delete with -delete

rm -f textput.log
mkdir -p compiled && mv $1.* compiled/ 
find ./compiled -not -name $1.tex -not -name $1.pdf -type f -delete
mv ./compiled/* . && rmdir compiled
mv $1.pdf ../Results/

