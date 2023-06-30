from keras.callbacks import ModelCheckpoint

from keras.layers import (
    Activation, Conv2D, Dense, Dropout, Flatten, MaxPooling2D
)

from keras.models import Sequential, load_model

from load_data import x_test, x_train, y_test, y_train

def create_model():
    """
    Create the model!!!!
    """
    model = Sequential()
    model.add(Conv2D(
        filters=10, kernel_size=(4, 4),
        input_shape=(28, 28, 1), padding='same'))
    model.add(Activation('relu')) # ?? what is relu?
    model.add(Dropout(0.4))
    model.add(MaxPooling2D(pool_size=(2, 2)))
    model.add(Conv2D(filters=40, kernel_size=(4, 4), padding='same'))
    model.add(Activation('relu'))
    model.add(Dropout(0.4))
    model.add(MaxPooling2D(pool_size=(2, 2)))
    model.add(Flatten())
    model.add(Dense(100, activation='relu'))
    model.add(Dropout(0.4))
    model.add(Dense(10, activation='softmax'))
    return model

initial_model = create_model()

def compile_model(model):
    model.compile(
        loss='categorical_crossentropy',
        optimizer='adadelta',
        metrics=['categorical_accuracy'])
    return model

compiled_model = compile_model(initial_model)

####### up until this point, we're only creating the structure of the model, but we're
# not doing anything with any acutal data...there's no references to the x and y training 


def fit_model(model):
    """
    train the model and store the best weights
    """
    checkpoint = ModelCheckpoint(
        filepath='models/mnist.hdf5',
        monitor='categorical_accuracy',
        save_best_only=True,
        mode='max'
    )

    # notice that this references the x and y _train_ variables...because we are training!
    model.fit(
        x_train,
        y_train,
        epochs=5,
        batch_size=100,
        validation_split=0.25,
        callbacks=[checkpoint])
    
    return model

print('\nTraining the model\n')
trained_model = fit_model(compiled_model)


# ?? I'm unclear on something.... this evaluate_model function loads the model off disk...
# That makes a ton of sense, but above in fit_model it has that ModelCheckpoint is
# set to "save best only", which should imply that every time i run the script,
# it will result in the-same-or-better prediction rates...but I have seen the numbers go down
# in the results shown in this function....
def evaluate_model():
    best_model = load_model('models/mnist.hdf5')
    train_score = best_model.evaluate(x_train, y_train)
    test_score = best_model.evaluate(x_test, y_test)
    return train_score, test_score

print('\nEvaluating the model...\n')
train_score, test_score = evaluate_model()

print('\nPercentage predicted correctly:\n')
print('Training:', train_score[1] * 100, '%')
print('Testing:', test_score[1] * 100, '%')

