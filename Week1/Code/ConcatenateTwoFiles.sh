#!/bin/bash

if [ -z $1 ] || [ -z $2 ] || [ -z $3 ] 
then echo "Provide 3 arguments"
     exit
fi

A=`basename $1`
B=`basename $2`
echo -e "\nMerging ${A} with ${B}...\n"

cat $1 > $3
cat $2 >> $3
echo "Merged File is:\n"
cat $3
