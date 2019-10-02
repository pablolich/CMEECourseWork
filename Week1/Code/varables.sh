!/bin/bash
# Author: Pablo Lechon pl1619@ic.ac.uk
# Script: variables.sh
# Desc: trying variables in bash
# Date: Oct 2019

#Shows the use of varables
MyVar='some string'
echo 'the current value of the variable is' $MyVar
echo 'Please enter a new string'
read MyVar
echo 'the current value of the variable is' $MyVar

## Reading multiple values
echo 'enter two numbers separated by space(s)'
read a b
echo 'you entered' $a 'and' $b '. Their sum is:' `expr $a + $b`
