#!/usr/bin/env python3

'''This script has two parts, the first part writes three separate lists
containing each subelement of the elements in the list birds using list 
comprehensions. The second part does the same thing using normal for loops'''

birds = ( ('Passerculus sandwichensis','Savannah sparrow',18.7),
          ('Delichon urbica','House martin',19),
          ('Junco phaeonotus','Yellow-eyed junco',19.5),
          ('Junco hyemalis','Dark-eyed junco',19.6),
          ('Tachycineata bicolor','Tree swallow',20.2),
         )

## FIRST_PART
#Write three separate list comprehensions that create three different
# lists containing the latin names, common names and mean body masses for
# each species in birds, respectively. 

#Latin names
latin = [birds[i][0] for i in range(len(birds))]

#Common names
common = [birds[i][1] for i in range(len(birds))]

#Mean masses
mass = [birds[i][2] for i in range(len(birds))]


## SECOND_PART
#Now do the same using conventional loops (you can choose to do this 
# before 1 !). 

#Latin names
latin_f = []
for i in range(len(birds)):
    latin_f.append(birds[i][0])

#Common names
common_f = []
for i in range(len(birds)):
    common_f.append(birds[i][1])

#Mean masses
mass_f = []
for i in range(len(birds)):
    mass_f.append(birds[i][2])

##Check
#_input = input('do you want to show the results? (y/n)')
#if _input == 'y':
#    print(latin, '\n', common, '\n', mass, '\n', latin_f, '\n', common_f, '\n'\
#          ,mass_f)








