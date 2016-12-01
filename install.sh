#!/bin/bash

echo
echo "Updating your packages"
echo

    sudo apt-get update
    sudo apt-get upgrade

echo
echo "Installing Dependencies..."
echo

    sudo apt-get -y install build-essential cmake pkg-config libjpeg-dev libtiff5-dev libjasper-dev libpng12-dev libavcodec-dev libavformat-dev libswscale-dev libv4l-dev libxvidcore-dev libx264-dev libgtk2.0-dev libatlas-base-dev gfortran python2.7-dev python3-dev

echo
echo "Downloading OpenCV 3.1.0..."
echo

    cd ~
    wget -O opencv.zip https://github.com/Itseez/opencv/archive/3.1.0.zip
    unzip -U opencv.zip

echo
echo "Downloading OpenCV_Contrib 3.1.0..."
echo

    cd ~
    wget -O opencv_contrib.zip https://github.com/Itseez/opencv_contrib/archive/3.1.0.zip
    unzip -U opencv_contrib.zip

echo
echo "Downloading and installing pip..."
echo

    wget https://bootstrap.pypa.io/get-pip.py
    sudo python get-pip.py

echo
echo "Downloading and installing virtualenv..."
echo

    sudo pip install virtualenv virtualenvwrapper
    sudo rm -rf ~/.cache/pip

    echo -e "\n# virtualenv and virtualenvwrapper" >> ~/.profile
    echo "export WORKON_HOME=$HOME/.virtualenvs" >> ~/.profile
    echo "source /usr/local/bin/virtualenvwrapper.sh" >> ~/.profile
    source ~/.profile

echo
echo "Creating python3 virtualenv..."
echo

    mkvirtualenv cv -p python3
    source ~/.profile

echo
echo "Switching to cv virtualenv..."
echo

    workon cv

echo
echo "Installing numpy..."
echo

    pip install numpy
    workon cv

echo
echo "Setting up OpenCV build..."
echo

    cd ~/opencv-3.1.0/
    mkdir build
    cd build
    cmake -D CMAKE_BUILD_TYPE=RELEASE \
        -D CMAKE_INSTALL_PREFIX=/usr/local \
        -D INSTALL_PYTHON_EXAMPLES=ON \
        -D OPENCV_EXTRA_MODULES_PATH=~/opencv_contrib-3.1.0/modules \
        -D BUILD_EXAMPLES=ON ..

echo
echo "Check the Python3 section"
echo
read -p "Press any key to continue... " -n1 -s

echo
echo "Compiling OpenCV..."
echo

    make -j4

echo
echo "Installing OpenCV..."
echo

    sudo make install
    sudo ldconfig

echo
echo "Finishing OpenCV..."
echo

    cd /usr/local/lib/python3.4/site-packages/
    sudo mv cv2.cpython-34m.so cv2.so
    cd ~/.virtualenvs/cv/lib/python3.4/site-packages/
    ln -s /usr/local/lib/python3.4/site-packages/cv2.so cv2.so