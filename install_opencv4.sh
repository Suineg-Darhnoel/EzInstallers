#!/bin/bash
# ------------------------------------------ #
# 2020, 2021
# Install latest version of OpenCV for C++
# Ubuntu 18.04, 20.04
# with bash script
# AUTHOR: Suineg-Darhnoel
# ------------------------------------------ #

# ------------------------------------------ #
# STYLE
# ------------------------------------------ #

GOOD='\033[1;32m'
BAD='\033[1;31m'
OFF='\033[m'

# ------------------------------------------ #
# INIT
# ------------------------------------------ #
SUCCESS=0 # installation flag

# configuration list
declare -A LIST=(
    [CMAKE_INSTALL_PREFIX]="/usr/local"
    [USE_EIGEN]="/usr/include/eigen3"
    [OPENCV_EXTRA_MODULES]="/opt/opencv_contrib/modules /opt/opencv"
    [BUID_EXAMPLES]=ON
    [INSTALL_C_EXAMPLES]=ON
    [BUILD_TESTS]=OFF
    [BUILD_PERF_TESTS]=OFF
    [WITH_TBB]=ON
    [WITH_V4L]=ON
    [WITH_QT]=ON
    [WITH_OPENGL]=ON
    [CMAKE_BUILD_TYPE]=RELEASE
    [OPENCV_GENERATE_PKGCONFIG]=ON
)

# dependency list
LIB_LIST=(

    cmake build-essential
    python-dev python-numpy # for python2
    python3-dev python3-numpy # for python3

    # GTK support for GUI features, Camera Support (v4l)
    # Media support (ffmpeg, gstreamer) etc
    libavcodec-dev libavformat-dev libswscale-dev
    libgstreamer-plugins-base1.0-dev libgstreamer1.0-dev
    libgtk2.0-dev libgtk-3-dev # gtk2, gtk3

    # Optional Dependencies
    # supporing files for image formats like
    # png, jpeg, jpeg2000, tiff, WebP etc

    v4l-utils
    libpng-dev
    libjpeg-dev
    libopenexr-dev
    libtiff-dev
    libjpeg-dev
    libavcodec-dev
    libavformat-dev
    libswscale-dev
    libxine2-dev
    libv4l-dev
    libtbb-dev
    libmp3lame-dev
    libopencore-amrnb-dev
    libopencore-amrwb-dev
    libtheora-dev
    libvorbis-dev
    x264
    libwebp-dev
    libopencv-dev
    libdc1394-22
    libdc1394-22-dev
    libqt4-dev

    # Intuitive user interface for multiple target
    qtbase5-dev qttools5-dev-tools qt5-default

    # eigen3 for linear algebra
    libeigen3-dev

);

# Use /opt as directory for cloning
# use command as root user

[ `whoami` = root ] || exec sudo su -c $0 root

echo "Opencv will be install at '/opt'"
cd /opt
# Indicate where the process is going to be done
echo "Current Directory :"$PWD

# ------------------------------------------ #
# INFORMATION FUNCTIONS
# ------------------------------------------ #

show_title(){
    msg=$1
    echo "# -------------------------------------------------- #"
    printf "#\t $1 \n"
    echo "# -------------------------------------------------- #"
    echo
}

show_dependencies(){
    show_title "HERE ARE THE DEPENDENCIES TO BE INSTALLED"
    for lib in ${LIB_LIST[@]}
    do
        echo -e "${GOOD}[${OFF} $lib ${GOOD}]${OFF}"
    done
}

confirm_msg(){
    echo
    read -r -p "$1 [y/N]: " response
    case "$response" in
        [yY][eE][sS]|[yY])
            echo -e "Installation [${GOOD}continue${OFF}]"
            ;;
        *)
            echo -e "Installation [${BAD}cancelled${OFF}]"
            exit 1
            ;;
    esac
}

# ------------------------------------------ #
# CHECKERS
# ------------------------------------------ #

# Check the existence of a file
# if not found, perform user's manual
# command line where the first argument
# is the file's name and the second
# argument is for the manual command line

check_local_opencv_dir(){
    show_title "CHECK LOCAL OPENCV DIRECTORIES EXISTENCE"
    if [ -e "$1" ]
    then
        echo "The file <$1> exists"
    else
        echo "The file <$1> does not exist"
        # need root priviledge to clone
        eval "$2"
    fi
}

check_opencv4_existence(){
    # To test if OpenCV has been installed successfully
    pkg-config --cflags --libs opencv4
}

check_installation(){
    PROG_MSG=$1
    TARGET=$2
    WARNING_MSG=$3

    if grep -q "${TARGET}" <<< "$PROG_MSG";then
        SUCCESS=0
        echo -e "OPENCV4 installation ${BAD}[${OFF} FAILED ${BAD}]${OFF}"
        echo "Please check if there are some mistakes before reinstalling"
    else
        SUCCESS=1
        echo -e "OPENCV4 ${GOOD}[${OFF} installed ${GOOD}]${OFF}"
    fi
}

# ------------------------------------------ #
# INSTALLERS
# ------------------------------------------ #

install_dependencies(){
    # BUILDING OpenCV from source
    confirm_msg "Do you want to install the dependencies now?"
    show_title "INSTALL DEPENDENCIES"
    sudo apt install -y ${LIB_LIST[@]}
}

get_source(){
    show_title "FETCH SOURCE FROM GIT REPO"
    # Use sudo git here, because it's required
    # user's priviledge to access the /opt directory
    CV="opencv"
    GIT_CLONE="sudo git clone"
    GIT_PATH="https://github.com/Itseez" # OpenCV is currently supported by Itseez
    INSTALL_OPENCV_CMD="$GIT_CLONE $GIT_PATH/$CV.git" # Command line used to clone opencv repo

    # check if the file opencv exists
    # if not found then git clone the repo
    echo $INSTALL_OPENCV
    check_local_opencv_dir $CV "$INSTALL_OPENCV_CMD"

    CV_CONTRIB="opencv_contrib"
    # Command line used to clone opencv_contrib repo
    INSTALL_OPENCV_CONTRIB_CMD="$GIT_CLONE $GIT_PATH/$CV_CONTRIB.git"

    # check if the file opencv_contrib exists
    # if not found then git clone the repo
    echo $INSTALL_OPENCV_CONTRIB
    check_local_opencv_dir $CV_CONTRIB "$INSTALL_OPENCV_CONTRIB_CMD"

    RL_DIR="release"
    MK_RL='sudo mkdir "$RL_DIR"'
    check_local_opencv_dir $RL_DIR "$MK_RL"
    cd $RL_DIR
    echo $PWD
}

cmake_start(){
    show_title "START CMAKE"
    MYCONFIG=""
    echo ">> CURRENT CONFIG <<"
    for i in ${!LIST[@]};do
        set -- $i
        echo -e "${GOOD}[${OFF} $1=${LIST[$i]} ${GOOD}]${OFF}"
        MYCONFIG+=" -D$1=${LIST[$i]} "
    done
    sudo cmake $MYCONFIG
}

install_opencv4(){
    show_title "START INSTALLAING OPENCV4"
    confirm_msg "Are you sure to proceed installation?"

    # get user input for number of cores for installation process
    DEFAULT_CORES=4
    printf "Please insert the number of cores you want to use: "
    read CORE_NUM

    if [ $CORE_NUM == '' ];then
        CORE_NUM=$DEFAULT_CORES
    fi

    echo "sudo make -j$CORE_NUM"
    sudo make "-j$CORE_NUM"

    echo "sudo make install"
    sudo make install

    echo "sudo ldconfig"
    sudo ldconfig
}

# ------------------------------------------ #
# MAIN
# ------------------------------------------ #

main(){
    show_dependencies
    install_dependencies
    get_source

    confirm_msg "Do you want to finish installing OPENCV4"

    if [ -d /opt/opencv ];then
        cmake_start
        install_opencv4
    fi

    PKG_MSG="$(check_opencv4_existence)"
    check_installation $PKG_MSG "No package"

    if [[ $SUCCESS -eq 1 ]];then
        echo -e "--------- FOUND ------------"
        for i in ${PKG_MSG[@]};do
            echo -e "${GOOD}[${OFF} $i ${GOOD}]${OFF}"
        done
    fi
}

main # call main function
