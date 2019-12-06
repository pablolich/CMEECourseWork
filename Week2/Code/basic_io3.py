#!/usr/bin/env python3

#############################
# STORING OBJECTS
# #############################
# To save an object (even complex) for a later use

my_dictionary = {"a key" : 10, "another key" : 11}

import pickle

f = open('../Sandbox/testp.p' , 'wb')
pickle.dump(my_dictionary, f)
f.close()

## Load the data again

f = open('../Sandbox/testp.p', 'rb')
another_dictionary = pickle.load(f)
f.close()

print(another_dictionary)
