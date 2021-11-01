from scipy.linalg import eigh
import numpy as np
import matplotlib.pyplot as plt

# N x D dataset. N = # of images, D = dimensions of each image

def load_and_center_dataset(filename):
    dataset = np.load(filename) # get dataset
    centered = dataset - np.mean(dataset, axis = 0)
    return centered

def get_covariance(dataset):
    return np.dot(np.transpose(dataset), dataset)/(len(dataset) - 1)

def get_eig(S, m):
    eigenvalues, eigenvectors = eigh(S, subset_by_index=[len(S)-m, len(S)-1])

    #Sort in descending order

    # to get the ith column vector we use u = v[:,i]
    index = np.argsort(eigenvalues)[::-1]
    eigenvalues = eigenvalues[index]
    eigenvectors = eigenvectors[:,index]

    diag = np.diag(eigenvalues)
    return diag, eigenvectors

def get_eig_perc(S, perc):
    eigenvalues, eigenvectors = eigh(S)
    sum = np.sum(eigenvalues)

    index = np.argsort(eigenvalues)[::-1]
    eigenvalues = eigenvalues[index]
    eigenvectors = eigenvectors[:,index]

    # Gets indeces of high variance eigenvalues and sorts arrays accordingly
    eigenvalues = eigenvalues[eigenvalues > sum*perc]
    indeces = np.argwhere(eigenvalues > sum*perc)
    indeces = np.ndarray.flatten(indeces)
    eigenvectors = eigenvectors[:,indeces]
    
    diag = np.diag(eigenvalues)
    return diag, eigenvectors



def project_image(img, U):
    sums = []
    for j in range(np.size(U, 1)):
        aij = np.dot(np.transpose(U[:,j]), img)
        result = np.dot(aij, U[:,j])
        sums.append(result)

    return sum(sums)

def display_image(orig, proj):
    reshaped_orig = np.transpose(np.reshape(orig, (32,32)))
    reshaped_proj = np.transpose(np.reshape(proj, (32,32)))

    fig, axs = plt.subplots(1, 2)
    axs[0].set_title('Original')
    axs[1].set_title('Projection')

    fig.colorbar(axs[0].imshow(reshaped_orig, aspect = 'equal'), ax=axs[0])
    fig.colorbar(axs[1].imshow(reshaped_proj, aspect = 'equal'), ax=axs[1])

    plt.show()