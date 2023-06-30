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
def one_hot_encode(integer, array_length):
    base = [0 for i in range(array_length)]
    base[integer] = 1
    return base

print('\none-hot-encode output:\n')
labels = array([one_hot_encode(label, 10) for label in tqdm(labels)])


def normalize_and_reshape(image):
    """
    This converts all values between 0..1 and reshapes the array.
    I guess the image comes in as a 1d array and this turns it into 
    a 28x28 array
    """
    return array([float(i) / 255 for i in image]).reshape(28, 28)

print('\nNormalize and reshape input images\n')
images = array([normalize_and_reshape(image) for image in tqdm(images)])


# Now it's time for something that I don't understand. The data set comes in 4 files..
# 2 of them are called "train" and the other two are signified with "t10k" which doesn't
# have an immediate google definition, but chatgpt says it basically means "10,000 test images"
# so I guess NIST just pre-slices data for you to make it easier to have a training set, 
# and then a physically separate test set which isn't included in the training set, so that 
# the model can be tested on new samples.
# But, this tutorial is re-slicing the data sets into 40k and 30k sizes
def split_data():
    """
    Apply our own custom split of training and testing data. 
    """
    x_train, y_train = images[:40000].reshape(40000, 28, 28, 1), labels[:40000]
    x_test, y_test = images[40000:].reshape(30000, 28, 28, 1), labels[40000:]
    return x_test, x_train, y_test, y_train

x_test, x_train, y_test, y_train = split_data()

############
# OK now we have data...onto the neural network!
# Normal "feed-forward" NNs use one dimensional arrays,
# and there's something special about convolutional neural networks
# where the convolution step ends up taking information as a multi-dimensional map about a single
# bit and also the neighboring bits to produce a sort of...metabit, or a 
# higher-order bit that represents information about a region in the space,
# and creates a new multidimensional map storing all of that information