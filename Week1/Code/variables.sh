#!/bin/bash
# Author: Pablo Lechon pl1619@ic.ac.uk
# Script: variables.sh
# Desc: trying variables in bash
# Date: Oct 2019

#Shows the use of varables
MyVar='some string'
echo -e '\nthe current value of the variable is' $MyVar
echo 'Please enter a new string'
read MyVar
echo 'the current value of the variable is' $MyVar
echo

## Reading multiple values
echo 'Enter two numbers separated by space(s)'
read a b
echo -e 'You entered' $a 'and' $b 
echo -e 'Their sum is:' `expr $a + $b`
echo

