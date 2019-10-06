#!/bin/bash
#Author: Pablo Lechon Alonso: plechon@ucm.es
#Script: csvtospace.sh
#Desc: transform csv files to space separated files
#Arguments: csv file
#Date: Oct 2019


cat $1 | tr -s "," " " > $2 
