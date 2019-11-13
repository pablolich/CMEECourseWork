##Look up p.stats!
import scipy as sc


def my_squares(iters):
    out = [i ** 2 for i in range(iters)]
    return out

def my_sqares_2(iters):
    out = sc.ones(iters)
    for i in range(iters):
        out[i] = i**2
    return out

def my_squares_3(iters):#the fastest
    mat = sc.matrix(sc.arange(iters))
    out = sc.multiply(mat, mat)
    return out

def my_join(iters, string):
    out = ''
    for i in range(iters):
        out += ", " + string
    return out

def run_my_funcs(x,y):
    print(x,y)
    my_squares(x)
    my_join(x,y)
    my_sqares_2(x)
    my_squares_3(x)
    return 0

run_my_funcs(30000000,"My string")
