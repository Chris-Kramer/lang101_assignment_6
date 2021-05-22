#!/usr/bin/env bash

VENVNAME=as6-cmk #Environment name
echo "Creating environment"
python -m venv $VENVNAME

# This makes sure that the bash script can be run from bash emulator on windows 
# Test if the folder bin in venvname exists
if [ -d "$VENVNAME/bin" ]

    then
        source $VENVNAME/bin/activate
        echo "Building venv for Linux/Mac ..."
    
    else
        source $VENVNAME/Scripts/activate
        echo "Building venv for Windows ..."
fi

echo "Upgrading pip and installing dependencies"
#Upgrade pip
# I'm specifying that I'm using pip from python, since my pc have problems upgrading pip locally if I don't do it.
python -m pip install --upgrade pip

echo "installing requirements"
# test requirements.txt and install
test -f requirements.txt && pip install -r requirements.txt

# Move to data folder
cd data/glove

#Download and unzip glove data
echo "downloading glove pre-trained data"
wget http://nlp.stanford.edu/data/glove.6B.zip
unzip -q glove.6B.zip

# Move to source folder
cd ../../src

#Run script
echo "running script"
python cnn-GOT.py $@

# Deavtivate environment
echo "deactivating and removing environment"
deactivate

#Remove glove data (So I can push repo to git)
cd ../data/glove
rm -rf glove.6B.zip
rm -rf *.txt
cd ../..

# Remove virtual environment
rm -rf $VENVNAME

echo "Done! The results can be found in the folder 'output'"