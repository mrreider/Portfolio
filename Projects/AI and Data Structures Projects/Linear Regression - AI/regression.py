import numpy as np
import csv
from matplotlib import pyplot as plt
import random


# Feel free to import other packages, if needed.
# As long as they are supported by CSL machines.


def get_dataset(filename):
    dataset = []
    i = 0
    with open(filename) as f:
        reader = csv.reader(f, quoting=csv.QUOTE_NONNUMERIC)
        for row in reader:
            if i != 0:
                del row[0]
                dataset.append(row)
            i += 1

    return np.array(dataset)


def print_stats(dataset, col):
    
    avg = sum(dataset[:,col])/ len(dataset)
    avg_f = "{:.2f}".format(avg)
    
    sq_sum = 0
    for x in dataset[:,col]:
        sq_sum += (x - avg)**2

    std_dev = np.sqrt(sq_sum/(len(dataset) - 1))
    std_dev_f = "{:.2f}".format(std_dev)

    print(len(dataset))
    print(avg_f)
    print(std_dev_f)

def regression(dataset, cols, betas):
    #First number selects column
    #Second number selects item in column
    mse_sum = 0

    for i in range(len(dataset)):
        temp_add = betas[0]
        for j in range(len(cols)):
            temp_add += betas[j + 1]* dataset[:,cols[j]][i]
        mse_sum += (temp_add - dataset[:,0][i])**2
    mse = mse_sum/len(dataset)
    return mse


def gradient_descent(dataset, cols, betas):
    ret = []
    for k in range(len(betas)):
        mse_sum = 0
        for i in range(len(dataset)):
            temp_add = betas[0]
            for j in range(len(cols)):
                temp_add += betas[j + 1]* dataset[:,cols[j]][i]
            if k == 0:
                mse_sum += (temp_add - dataset[:,0][i])
            else:
                mse_sum += (temp_add - dataset[:,0][i])*(dataset[:,cols[k - 1]][i])
        ret.append(2*mse_sum/len(dataset) )
    grads = np.array(ret)
    return grads


def iterate_gradient(dataset, cols, betas, T, eta):
    iterate_betas = betas
    for iterations in range(T + 1):
        statement = ""
        statement += str(iterations) + " "
        statement += str("{:.2f}".format(regression(dataset, cols, iterate_betas))) + " "
        for x in iterate_betas:
            statement += str("{:.2f}".format(x)) + " "
        if iterations != 0: 
            print(statement)

        new_betas = gradient_descent(dataset, cols, iterate_betas)
        for i in range(len(iterate_betas)):
            iterate_betas[i] = iterate_betas[i] - eta*new_betas[i]



def compute_betas(dataset, cols):
    X = []
    betas = []
    for row in range(len(dataset)):
        curr_row = []
        for column in range(len(cols) + 1):
            if column == 0:
                curr_row.append(1)
            else:
                curr_row.append(dataset[:,cols[column - 1]][row])
        X.append(curr_row)

    first = np.dot(np.transpose(X), X)
    second = np.dot(np.transpose(X), dataset[:,0])
    third = np.dot(np.linalg.inv(first), second)
    for x in third:
       betas.append(x)
    
    mse = regression(dataset, cols, betas)
    return (mse, *betas)


def predict(dataset, cols, features):
    compute = compute_betas(dataset, cols)
    thetas = np.array([1] + features)
    betas = np.array(compute[1:])

    return np.dot(thetas, betas)


def synthetic_datasets(betas, alphas, X, sigma):
    linear = []
    for i in range(len(X[0])):
        y = betas[0] + betas[1]*X[0][i] + np.random.normal(loc=0, scale = sigma)
        linear.append([y, X[0][i]])

    quad = []
    for j in range(len(X[0])):
        temp = alphas[0] + alphas[1]*(X[0][j]**2) + np.random.normal(loc=0, scale = sigma)
        quad.append([temp, X[0][j]])

    return np.array(linear), np.array(quad)


def plot_mse():
    from sys import argv
    if len(argv) == 2 and argv[1] == 'csl':
        import matplotlib
        matplotlib.use('Agg')

    X = []
    temp = []
    for i in range(1000):
        temp.append(random.randint(-100,100))
    X.append(temp)
    X = np.array(X)

    betas = np.array([1,1])
    alphas = np.array([1, 1])

    sigmas = [10e-4, 10e-3, 10e-2, 10e-1, 1, 10e1, 10e2, 10e3, 10e4, 10e5]
    datasets = []
    for x in sigmas:
        datasets.append(synthetic_datasets(betas, alphas, X, x))
    mses_lin = []
    mses_quad = []

    for y in datasets:
        lin, quad = y
        mses_lin.append(compute_betas(np.array(lin), cols=[1])[0])
        mses_quad.append(compute_betas(np.array(quad), cols=[1])[0])

    plt.yscale("log")
    plt.xscale("log")
    plt.xlabel("Standard Deviation of Error Terms")
    plt.ylabel("MSE of Trained Model")
    plt.plot(sigmas, mses_lin, '-o', label = "MSE of Linear Dataset")
    plt.plot(sigmas, mses_quad, '-o', label = "MSE of Quadratic Dataset")
    plt.legend()
    plt.savefig('mse.pdf')

if __name__ == '__main__':
    ### DO NOT CHANGE THIS SECTION ###
    plot_mse()