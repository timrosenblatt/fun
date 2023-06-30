from os import getcwd
from mnist import mnist
from numpy import array
from tqdm import tqdm

def get_mnist_data():
    """
    Open the mnist files and load them...
    This tutorial is combining training and testing data into a single list
    for some reason...let's play along!
    """
    data = MNIST(getcwd() + '/data')
    train_images, train_labels = data.load_training()
    test_images, test_labels = data.load_testing()

    # Why is this just using + to combine the images, but the labels are...in a different object type?
    images = train_images + test_images
    labels = list(train_labels) + list(test_labels)
    return images, labels

images, labels = get_mnist_data()

