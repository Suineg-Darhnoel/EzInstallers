#!/bin/bash

# 2020
# Install latest version of OpenCV for C++
# Ubuntu 18.04.4
# with bash script

# Use /opt as directory for cloning
cd /opt

# Indicate where the process is going to be done
echo "Current Directory :"$PWD

# BUILDING OpenCV from source
sudo apt-get install cmake
sudo apt-get install gcc g++

# to support python2
sudo apt-get install python-dev python-numpy

# to support python2
sudo apt-get install python3-dev python3-numpy

# gtk support for GUI features, Camera support (v4l), Media Support (ffmpeg, gstreamer) etc
sudo apt-get install libavcodec-dev libavforma-dev libswscale-dev
sudo apt-get install libgstreamer-plugins-base.0-dev libgstreamer1.0-dev

# to support gtk2
sudo apt-get install libgtk2.0-dev

# to support gtk3
sudo apt-get install libgtk-3-dev

# Optional Dependencies
# supporting files for image formats like
# png, jpeg, jpeg2000, tiff, WebP etc
sudo apt-get install libpng-dev \
                     libjpeg-dev \
                     libopenexr-dev \
                     libtiff-dev \
                     libwebp-dev

# Check the existence of a file
# if not found, perform user's manual
# command line where the first argument
# is the file's name and the second
# argument is for the manual command line
TestOpenCV(){
    if [ -e "$1" ]
    then
        echo "The file <$1> exists"
    else
        echo "The file <$1> does not exist"
        # need root priviledge to clone
        eval "$2"
    fi
}

# Use sudo git here, because it's required
# user's priviledge to access the /opt directory
GIT_CLONE="sudo git clone"

# OpenCV is currently supported by Itseez
GIT_PATH="https://github.com/Itseez"

CV="opencv"
# Command line used to clone opencv repo
INSTALL_OPENCV_CMD="$GIT_CLONE $GIT_PATH/$CV.git"

# check if the file opencv exists
# if not found then git clone the repo
echo $INSTALL_OPENCV
TestOpenCV $CV "$INSTALL_OPENCV_CMD"

CV_CONTRIB="opencv_contrib"
# Command line use dto clone opencv_contrib repo
INSTALL_OPENCV_CONTRIB_CMD="$GIT_CLONE $GIT_PATH/$CV_CONTRIB.git"

# check if the file opencv_contrib exists
# if not found then git clone the repo
echo $INSTALL_OPENCV_CONTRIB
TestOpenCV $CV_CONTRIB "$INSTALL_OPENCV_CONTRIB_CMD"

RL_DIR="release"
MK_RL='mkdir "$RL_DIR"'
TestOpenCV $RL_DIR "$MK_RL"
cd $RL_DIR
echo $PWD

cmake -D BUILD_TIFF=ON \
      -D WITH_CUFA=OFF \
      -D ENABLE_AVX=OFF \
      -D WITH_OPENGL=OFF \
      -D WITH_OPENCL=OFF \
      -D WITH_IPP=OFF \
      -D WITH_EIGEN=OFF \
      -D WITH_V4L=OFF \
      -D WITH_VTK=OFF \
      -D WITH_1394=OFF \
      -D BUILD_TESTS=OFF \
      -D BUILD_PERF_TESTS=OFF \
      -D CMAKE_BUILD_TYPE=RELEASE \
      -D OPENCV_GENERATE_PKGCONFIG=ON \
      -D CMAKE_INSTALL_PREFIX=/usr/local \
      -D OPEN_CV_EXTRA_MODULES=/opt/opencv_contrib/modules /opt/opencv/

make -j10
make install
ldconfig

# To test if OpenCV has been installed successfully
pkg-config --cflags --libs opencv4
