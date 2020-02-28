import scipy as sc
from fitting import load_data, unique_id
from fit_model import init_vals
import matplotlib.pylab as plt

data = load_data()
data['unique_id'] = unique_id(data)
ids = list(set(data.unique_id))
N = len(ids)
for i in range(N):
    #Get data to fit
    fit_data = data[data.unique_id == ids[i]]
    t = sc.array(fit_data.Time, dtype = 'float64')
    population = sc.array(fit_data.PopBio, dtype = 'float64')
    p, grad_max = init_vals(t,population)
    import ipdb; ipdb.set_trace(context = 20)
    plt.scatter(t,population)
    plt.scatter(t,population)
    plt.plot(t, p+grad_max*t)
    plt.savefig('../Results/linefit'+str(i)+'.pdf')
    plt.close()


