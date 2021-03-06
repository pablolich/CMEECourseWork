#!/usr/bin/env python3

'''In this script we print the information of each species contained in the
tuple in one output block per species'''

birds = ( ('Passerculus sandwichensis','Savannah sparrow',18.7),
          ('Delichon urbica','House martin',19),
          ('Junco phaeonotus','Yellow-eyed junco',19.5),
          ('Junco hyemalis','Dark-eyed junco',19.6),
          ('Tachycineata bicolor','Tree swallow',20.2),
        )

# Birds is a tuple of tuples of length three: latin name, common name, mass.
# write a (short) script to print these on a separate line or output block by 
# species 
# Hints: use the "print" command! You can use list comprehensions!

[print('\n', 'Latin Name:', i[0],'\n', 'Common Name:', i[1], '\n', 'Mass:', \
       i[2], '\n') for i in birds]
