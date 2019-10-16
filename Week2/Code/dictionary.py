#!/usr/bin/env python3 

''' Write a short python script to populate a dictionary called taxa_dic 
derived from  taxa so that it maps order names to sets of taxa. E.g.
'Chiroptera' : set(['Myotis lucifugus']) etc.''' 


taxa = [ ('Myotis lucifugus','Chiroptera'),
         ('Gerbillus henleyi','Rodentia',),
         ('Peromyscus crinitus', 'Rodentia'),
         ('Mus domesticus', 'Rodentia'),
         ('Cleithrionomys rutilus', 'Rodentia'),
         ('Microgale dobsoni', 'Afrosoricida'),
         ('Microgale talazaci', 'Afrosoricida'),
         ('Lyacon pictus', 'Carnivora'),
         ('Arctocephalus gazella', 'Carnivora'),
         ('Canis lupus', 'Carnivora')
        ]


#Create a set containing the possible order names

order_names = set([i[1] for i in taxa])

#Create an empty dictionary with appropiate keys: order_names

dict_names = {i:[] for i in order_names}

#Populate the dictionary

for i in order_names:
    #if the key is the same, add the species to the dictionary
    [dict_names[i].append(j[0]) for j in taxa if j[1] == i]

print(dict_names)
