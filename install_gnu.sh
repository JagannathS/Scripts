#!/bin/bash

############################################################################
#
# Usage: 
# Change the permission for the script file to execute chmod +x install_gnu.sh
# Run the script file ./install_gnu.sh
# Installs the GNU Radio <https://www.gnuradio.org/> from source including all dependancies
# Created and Tested on Ubuntu 20.04 LTS Verion
# Created by Jagannath S <jagsowjagnath@gmail.com>
#
# Limitations: 
#  Created to extract user home directory on a single user ubuntu machine, multi user not tested
#
############################################################################

# Install all dependancies
sudo apt install git cmake g++ libboost-all-dev libgmp-dev swig python3-numpy python3-mako python3-sphinx python3-lxml doxygen libfftw3-dev libsdl1.2-dev libgsl-dev libqwt-qt5-dev libqt5opengl5-dev python3-pyqt5 liblog4cpp5-dev libzmq3-dev python3-yaml python3-click python3-click-plugins python3-zmq python3-scipy python3-gi python3-gi-cairo gir1.2-gtk-3.0 libcodec2-dev libgsm1-dev pybind11-dev python3-matplotlib libsndfile1-dev libiio-dev libad9361-dev libsoapysdr-dev soapysdr-tools git -y

#Extract User home directory, by default the user ID created is 1000,  $3 extracts user ID , $6 prints the user home directory
# in case you want to change the id to name change $3 >= 1000 && $3 <2000 in below statement to $1==<username>
# Default download directory for source code is user home downloads folder, 

$HOMEDIR = `awk -F: ' $3 >= 1000 && $3 <2000 {print $6}' /etc/passwd`

#Install volk from source
cd $HOMEDIR/Downloads
git clone --recursive https://github.com/gnuradio/volk.git
cd volk
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Release -DPYTHON_EXECUTABLE=/usr/bin/python3 ../
make -j`nproc`
make test -j`nproc`
sudo make install
sudo ldconfig
     
#Install gnuradio from source	 
cd /home/lte/Downloads
git clone https://github.com/gnuradio/gnuradio.git
cd gnuradio
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Release -DPYTHON_EXECUTABLE=/usr/bin/python3 ../
make -j`nproc`
make test -j`nproc`
sudo make install
sudo ldconfig

#Set library paths for running gnuradio-companion
echo "export PYTHONPATH=/usr/local/lib/python3/dist-packages:/usr/local/lib/python3.6/dist-packages:$PYTHONPATH" >> /home/lte/.bashrc
echo "export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH" >> /home/lte/.bashrc
export PYTHONPATH=/usr/local/lib/python3/dist-packages:/usr/local/lib/python3.6/dist-packages:$PYTHONPATH
export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH

sudo ldconfig

#Run volk profile for optimizing volk for usage on the system
volk_profile