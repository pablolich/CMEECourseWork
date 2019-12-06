#!/usr/bin/env python3

'''
Find directories and files that satisfy certain conditions using subprocess
'''

import subprocess
import numpy as np

# Use the subprocess.os module to get a list of files and  directories 
# in your ubuntu home directory 
# Get the user's home directory.
home = subprocess.os.path.expanduser("~")
subprocess.os.listdir(path = home)

# Hint: look in subprocess.os and/or subprocess.os.path and/or 
# subprocess.os.walk for helpful functions

#################################
#~Get a list of files and 
#~directories in your home/ that start with an uppercase 'C'

# Type your code here:
# Create a list to store the results.

# Use a for loop to walk through the home directory.
l_root = []
l_subdir = []
l_files = []
for (root, subdir, files) in subprocess.os.walk(home):
    l_subdir.append(subdir)
    l_files.append(files)

#Make flat list from list of lists
l_directories = [j for i in l_subdir for j in i]
l_files_ = [j for i in l_files for j in i]

#Select only those that start with C
dir_C = [i for i in l_directories if i.startswith('C')]
files_C = [i for i in l_files_ if i.startswith('C')]

#Join lists
DirFiles_C = dir_C + files_C
print('Directories and Files that start with C\n')
print(DirFiles_C, '\n')
#################################
# Get files and directories in your home/ that start with either an 
# upper or lower case 'C'

# Type your code here:
#Select only those that start with C or c

dir_C_c = [i for i in l_directories if i.lower().startswith('c')]
files_C_c = [i for i in l_files_ if i.lower().startswith('c')]

#Join lists
DirFiles_C_c = dir_C_c + files_C_c
print('Directories and Files that start with C or c\n')
print(DirFiles_C_c, '\n')
#################################
# Get only directories in your home/ that start with either an upper or 
#~lower case 'C' 

# Type your code here:
Dir_C_c = dir_C_c
print('Directories that start with C or c\n')
print(Dir_C_c, '\n')
