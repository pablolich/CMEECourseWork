#!/usr/bin/env python3

'''Open a file for reading'''

#############################
# FILE INPUT
#############################
f = open('../Sandbox/test.txt', 'r')
# use "implicit" for loop:
# if the object is a file, python will cycle over lines
for line in f:
    print(line)

# close the file
f.close()

# Same example, skip blank lines
f = open('../Sandbox/test.txt', 'r')
if len(line.strip()) > 0:
    for line in f:
        print(line)
f.close()
