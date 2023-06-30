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

# So this is apparently called a "one-hot-encoding of the outputs".
# https://www.geeksforgeeks.org/ml-one-hot-encoding-of-datasets-in-python/#
# I guess it's just making a large array/bitmask of all possible states, 
# and then only one of the bits is marked as one...it's like creating a ton of boolean
# columns in a DB and using them as an enum, instead of having one single field with an int
# mapped to each enum...and this is good b/c it lets you use numbers as values which
# seem to be easier to work with...either certain tools or models?
# also it somehow provides more information to the model about the "categorical variable"...
# which I guess emerges b/c if you have one value that has 10 different options, some models
# might not understand the cardinality/variety of possible values, but if each value is mapped as a certain
# number of columns, the information about the number of possibilities is more "available" to the 
# models?
# The last one kinda seems to make the least sense... "avoiding ordinality" when a category var has
# a natural ordering.... somehow some models get biased towards certain numbers, like 1 instead of 0?
# Will have to learn more about that.


