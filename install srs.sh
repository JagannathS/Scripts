#!/bin/bash

############################################################################
#
# Usage: 
# Change the permission for the script file to execute chmod +x install_srs.sh
# Run the script file ./install_srs.sh
# Installs the SRSRan <https://www.srs.io/> from source including all dependancies
# Created and Tested on Ubuntu 20.04 LTS Verion
# Created by Jagannath S <jagsowjagnath@gmail.com>
#
# Limitations: 
#  Created to extract user home directory on a single user ubuntu machine, multi user not tested
#
############################################################################

# Install all dependancies
sudo apt-get install build-essential cmake libfftw3-dev libmbedtls-dev libboost-program-options-dev libconfig++-dev libsctp-dev libboost-all-dev libusb-1.0-0-dev doxygen python3-docutils python3-mako python3-numpy python3-requests python3-ruamel.yaml python3-setuptools cmake build-essential libzmq3-dev git -y

#this is used by me for streaming video from UE, if not needed comment below 2 lines
snap install mjpg-streamer
snap connect mjpg-streamer:camera

#Extract User home directory, by default the user ID created is 1000,  $3 extracts user ID , $6 prints the user home directory
# in case you want to change the id to name change $3 >= 1000 && $3 <2000 in below statement to $1==<username>
# Default download directory for source code is user home downloads folder, 

$HOMEDIR = `awk -F: ' $3 >= 1000 && $3 <2000 {print $6}' /etc/passwd`

#Install uhd from source, this installs the latest verion
cd $HOMEDIR/Downloads
git clone https://github.com/EttusResearch/uhd.git
# shift to a branch here using git checkout command if needed, uncomment below line and update branch required
# git checkout UHD-3.15.LTS
cd uhd/host
mkdir build
cd build
cmake ../
make -j`nproc`
make test -j`nproc`
sudo make install
sudo ldconfig
#Download usrp images
uhd_images_downloader

#Install srsGUI from source, this is optional comment the section if srsGUI is not required
cd $HOMEDIR/Downloads
git clone https://github.com/srsran/srsGUI.git
cd srsGUI
mkdir build
cd build
cmake ../
make
make test -j`nproc`
sudo make install
sudo ldconfig

#Install srsRAN from source
cd $HOMEDIR/Downloads
git clone https://github.com/srsRAN/srsRAN.git
cd srsRAN
mkdir build
cd build
cmake ../
make -j`nproc`
make test -j`nproc`
sudo make install
#install default configurations to run SRSRAN components
srsran_install_configs.sh user
sudo ldconfig
