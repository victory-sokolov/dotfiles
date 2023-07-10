#!/bin/zsh
# shellcheck shell=bash

# Build OpenCV from source
sudo apt-get update && sudo apt-get upgrade -y

	sudo apt-get install \
		build-essential \
		cmake \
		git \
		libgtk2.0-dev \
		pkg-config \
		libavcodec-dev l \
		libjpeg-dev \
		libpng-dev \
		libtiff5-dev \
		libjasper-dev \
		libdc1394-22-dev \
		libeigen3-dev li

	# Download OpenCV source
	mkdir opencv && cd opencv || exit
	git clone https://github.com/Itseez/opencv.git
	git clone https://github.com/Itseez/opencv_contrib.git

	# Build & Install OpenCV
	mkdir release && cd release || exit

	cmake \
		-D BUILD_TIFF=ON \
		-D WITH_CUDA=OFF \
		-D ENABLE_AVX=OFF \
		-D WITH_OPENGL=OFF \
		-D WITH_OPENCL=OFF \
		-D WITH_IPP=OFF \
		-D WITH_TBB=ON \
		-D BUILD_TBB=ON \
		-D WITH_EIGEN=OFF \
		-D WITH_V4L=OFF \
		-D WITH_VTK=OFF \
		-D BUILD_TESTS=OFF \
		-D BUILD_PERF_TESTS=OFF \
		-D OPENCV_GENERATE_PKGCONFIG=ON \
		-D CMAKE_BUILD_TYPE=RELEASE \
		-D CMAKE_INSTALL_PREFIX=/usr/local \
		-D OPENCV_EXTRA_MODULES_PATH=/opt/opencv_contrib/modules /opt/opencv/

	 make -j4
	 make install
	 ldconfig

	 # Set OpenCV file path
	 sudo cp /usr/local/lib/pkgconfig/opencv4.pc  /usr/lib/x86_64-linux-gnu/pkgconfig/opencv.pc
