#!/usr/bin/env python3

'''Learning how to use __name__ = "_main__"'''

#Filename: using_name.py

if __name__ == '__main__':
    print('This program is being run by itself')
else:
    print('I am being imported from another module')

