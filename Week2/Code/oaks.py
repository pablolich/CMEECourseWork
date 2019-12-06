#!/usr/bin/env python3

'''Comparing list comprehension with normal loops'''

taxa = ['Quercus robur' ,
        'Fraxinus excelsior' ,
        'Pinus sylvestris' ,
        'Quercus petraea' 
       ]

def is_an_oak(name):
    return name.lower().startswith('quercus')

##Using for loops
oaks_loops = set()
for species in taxa:
    if is_an_oak(species):
        oaks_loops.add(species)
print(oaks_loops)

##Using list comprehensions
oaks_lc = set([species for species in taxa if is_an_oak(species)])
print(oaks_lc)

##Get names in UPPERCASE using for loops
oaks_loops = set()
for species in taxa:
    if is_an_oak(species):
        oaks_loops.add(species.upper())
print(oaks_loops)

##Get names in UPPERCASE using for list comprehensions
oaks_lc = set([species.upper()for species in taxa if is_an_oak(species)])
print(oaks_lc)

