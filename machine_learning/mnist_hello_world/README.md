<https://medium.com/the-andela-way/deep-learning-hello-world-e1fc53ea888> looks like a slightly old, but reasonable blog post to follow along with

Sadly the MNIST image database that the post links to is behind HTTP auth..seems to be the main one that a lot of tutorials use. Not sure if that's a temporary thing since it's so widely referenced, but I think <https://github.com/cvdfoundation/mnist> seems to be a solid mirror, so I'm going to try the tutorial with that. 

# Dev cycle

I'm setting up venv to manage the deps but they would otherwise be
`python-mnist tensorflow keras tqdm h5py`

To start the venv to run the scripts

`source ./venv/bin/activate`

And then reinstall the dependencies if needed
`pip install -r requirements.txt`

then run the CNN

`python network.py`

and when done just type 

`deactivate`

