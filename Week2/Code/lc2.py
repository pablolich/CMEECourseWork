#!/usr/bin/env python3


'''This script extends on the work of lc1.py, but this time, working with 
tuples
'''


# Average UK Rainfall (mm) for 1910 by month
# http://www.metoffice.gov.uk/climate/uk/datasets
rainfall = (('JAN',111.4),
            ('FEB',126.1),
            ('MAR', 49.9),
            ('APR', 95.3),
            ('MAY', 71.8),
            ('JUN', 70.2),
            ('JUL', 97.1),
            ('AUG',140.2),
            ('SEP', 27.0),
            ('OCT', 89.4),
            ('NOV',128.4),
            ('DEC',142.2),
           )

# (1) Use a list comprehension to create a list of month,rainfall tuples where
# the amount of rain was greater than 100 mm.
 
rain_100 = [(i[0], i[1]) for i in rainfall if i[1]>100]

# (2) Use a list comprehension to create a list of just month names where the
# amount of rain was less than 50 mm. 

rain_50 = [i[0] for i in rainfall if i[1]<50]

# (3) Now do (1) and (2) using conventional loops (you can choose to do 
# this before 1 and 2 !). 

#1_f

rain_100_f = []
for i in rainfall:
    if i[1]>100:
        rain_100_f.append(i)

#2_f

rain_50_f = []
for i in rainfall:
    if i[1]<50:
        rain_50_f.append(i[0])

##Check
#_input = input('do you want to show the results? (y/n)')
#if _input == 'y':
#    print(rain_100, '\n', rain_50, '\n', rain_100_f, '\n', rain_50_f)
