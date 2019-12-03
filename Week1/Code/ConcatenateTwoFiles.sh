#!/bin/bash

if [ -z $1 ]
then echo "Provide argumens"
     exit
fi

cat $1 > $3
cat $2 >> $3
echo "Merged File is:\n"
cat $3
