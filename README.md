# Installers
This directory will be used for quick-installing tools that will save us tons of time when we are to install the same packages on our new development environment. Some of us may already have experienced when it comes to installing sophisticated libraries such as `opencv` where the installing process involves complicated configurations and execution steps. That is indeed time consuming since following wrong installation steps may lead to headache googling troubles. Therefore, we as a whole only need a one-time installing tool to finish everything, and save time for pizza.

# Idea in a Nutshell
As an example, let's see how [install\_opencv4] works.
On my new computer, I want to install `opencv4.5.1`. What i need to do is asking myself in which directory I should put the source files, and response to the [y/N] confirmations, and let the [install_opencv4] do the trick. Here is how it can be seen on our terminal:

```console
foo@bar:~$ ./install_opencv4.sh 
dir </opt/opencv451> exists.
OpenCV will be installed at </opt/opencv451>
Current Directory :/opt/opencv451
# -------------------------------------------------- #
#	 HERE ARE THE DEPENDENCIES TO BE INSTALLED 
# -------------------------------------------------- #

[ cmake ]
[ build-essential ]
[ python-dev ]
[ python-numpy ]
[ python3-dev ]
[ python3-numpy ]
[ libavcodec-dev ]
[ libavformat-dev ]
[ libswscale-dev ]
[ libgstreamer-plugins-base1.0-dev ]
[ libgstreamer1.0-dev ]
[ libgtk2.0-dev ]
[ libgtk-3-dev ]
[ v4l-utils ]
[ libpng-dev ]
[ libjpeg-dev ]
[ libopenexr-dev ]
[ libtiff-dev ]
[ libjpeg-dev ]
[ libavcodec-dev ]
[ libavformat-dev ]
[ libswscale-dev ]
[ libxine2-dev ]
[ libv4l-dev ]
[ libtbb-dev ]
[ libmp3lame-dev ]
[ libopencore-amrnb-dev ]
[ libopencore-amrwb-dev ]
[ libtheora-dev ]
[ libvorbis-dev ]
[ x264 ]
[ libwebp-dev ]
[ libopencv-dev ]
[ libdc1394-22 ]
[ libdc1394-22-dev ]
[ libqt4-dev ]
[ qtbase5-dev ]
[ qttools5-dev-tools ]
[ qt5-default ]
[ libeigen3-dev ]

Do you want to install the dependencies now? [y/N]: N
Installation [cancelled]

```
# Tweaking
If you want to clone in different directory, just look at [install\_opencv4] and find `OPENCV_DIR` and change it to your desired path.
*HINT*: `OPENCV_DIR='/path/to/youropencv/'`
```bash
# ------------------------------------------ #
# INIT
# ------------------------------------------ #
# assign the right directory where you
# want the installation to start
OPENCV_DIR='/opt/opencv451'
```
