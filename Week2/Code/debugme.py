def makeabug(x):
    y = x**4
    z = 0.
    y = y/z
    import ipdb; ipdb.set_trace(context = 20)
    return y

makeabug(25)
