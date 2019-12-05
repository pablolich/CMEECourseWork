#!/bin/bash

#In this bash script we run through all the tiff files specified in the directory ($1). 
#Convert them into jpg files
#Move them to the sandbox directory.

if [ -z $1 ]
then echo "Provide an argument"
     exit
fi

if [[ $1 == *".tif"* ]];
then echo "Provide the name of the file without the extension"
    exit
fi

for f in $1*.tiff 
    do
	echo "Converting $f";
	convert "$f" "$(basename "$f" .tiff).jpg";
    done
mv *.jpg ../Sandbox/
echo "Done!"

