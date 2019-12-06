##Example 1

'''Variable scope. Variables inside the functions remain inside the functions
unless I do global variablename. Variables outside the function filter to 
the function until you change their value inside the function.'''



_a_global = 10 #a global variable

if  _a_global >=5:
    _b_global = _a_global + 5 #also a global variable

def a_function():
    '''Testing scope of variables'''
    _a_global = 5 #a local variable

    if _a_global >= 5:
        _b_global = _a_global + 5 # also a local variable

        _a_local = 4

        print('\nExample1:')
        print("Inside the function, the value of _a_global is", _a_global)
        print("Inside the function, the value of _b_global is", _b_global)
        print("Inside the function, the value of _a_global is", _a_global)

        return None

a_function()

print("Outside the function, the value of _a_global is ", _a_global)
print("Outside the function, the value of _b_global is ", _b_global,'\n')

##Example 2

_a_global = 10

def a_function():
    '''Testing scope of variables'''
    _a_local = 4

    print("Example 2:")
    print("Inside the function, the value of _a_local is ", _a_local)
    print("Inside the function, the value of _a_global is ", _a_global)

    return None

a_function()

print("Outside the function, the value of _a_global is", _a_global, '\n')

##Example 3

_a_gloabl = 10

print('Example 3:')
print("Outside the function, the value of _a_global is ", _a_global)

def a_function():
    '''Testing scope of variables'''
    global _a_global
    _a_global = 5
    _a_local = 4

    print("Inside the function, the value of _a_global is", _a_global)
    print("Inside the function, the value of _a_local is ", _a_local)

    return None

a_function()

print("Outside the function, the value of _a_global now is", _a_global, '\n')

##Tricky example
'''In this example using the global keyword inside the inner function
_a_function2 results in changing the value of _a_global in the main workspace 
/ namespace to 20, but within the scope of _a_function it remained 10'''

def a_function():
    '''Testing scope of variables'''
    _a_global = 10

    def _a_function2():
        '''Testing scope of variables'''
        global _a_global
        _a_global = 20

    print("Before calling a_function, value of _a_global is", _a_global)

    _a_function2()

    print("After calling _a_function2, value of _a_global is", _a_global)

a_function()

print("The value of a_global in main workspace / namespace is", _a_global)
_a_global = 10

##Final example
'''Now, because _a_global was defined in advance (outside the first function),
it get modified when changes in the inner function (it does not exist as a 
locsl within the scope of _a_function, but is inherited from the main scope
/ workspace / namespace )'''


def a_function():
    '''Testing scope of variables'''

    def _a_function2():
        '''Testing scope of variables'''
        global _a_global
        _a_global = 20

    print("Before calling a_function, value of _a_global is ", _a_global)

    _a_function2()

    print("After calling _a_function2, value of _a_global is ", _a_global)

a_function()

print("The value of a_global in main workspace / namespace is ", _a_global)


