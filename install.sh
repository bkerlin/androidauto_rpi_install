#!/bin/bash

##
# Script for Android Auto (OpenAuto) install on RPi
# Original install instructions https://github.com/f1xpl/openauto/wiki/Build-instructions
#
# Compatible only with Raspbeery PI 3 or newer (Stretch)
##

# Installing dependeces
cls
echo "OpenAuto RPi install script by novaspirit"
echo 
echo "Installing dependences..."
sudo apt-get update
sudo apt-get install -y libboost-all-dev libusb-1.0.0-dev libssl-dev cmake libprotobuf-dev protobuf-c-compiler protobuf-compiler libqt5multimedia5 libqt5multimedia5-plugins libqt5multimediawidgets5 qtmultimedia5-dev libqt5bluetooth5 libqt5bluetooth5-bin qtconnectivity5-dev pulseaudio librtaudio-dev
echo "...done."

# Cloning and building Android Auto SDK
echo "Cloning and building Android Auto SDK..."
cd
git clone -b master https://github.com/f1xpl/aasdk.git
mkdir aasdk_build
cd aasdk_build
cmake -DCMAKE_BUILD_TYPE=Release ../aasdk
make -j4
echo "...done."

# Building ilclient firmware
echo "Building ilclient firmware..."
cd /opt/vc/src/hello_pi/libs/ilclient
make -j4
echo "...done."

# Cloning and building OpenAuto 
echo "Cloning and building OpenAuto..."
cd
git clone -b master https://github.com/f1xpl/openauto.git
mkdir openauto_build
cd openauto_build
cmake -DCMAKE_BUILD_TYPE=Release -DRPI3_BUILD=TRUE -DAASDK_INCLUDE_DIRS="/home/pi/aasdk/include" -DAASDK_LIBRARIES="/home/pi/aasdk/lib/libaasdk.so" -DAASDK_PROTO_INCLUDE_DIRS="/home/pi/aasdk_build" -DAASDK_PROTO_LIBRARIES="/home/pi/aasdk/lib/libaasdk_proto.so" ../openauto
make -j4
echo "...done."

# Enabling OpenAuto autostart
if (whiptail --title "OpenAuto RPi" --yesno "Would you like to enable OpenAuto to autostart?" 8 78); then
    echo "Enabling OpenAuto autostart..."
    echo "sudo /home/pi/openauto/bin/autoapp" >> /home/pi/.config/lxsession/LXDE-pi/autostart
    echo "...done."
else
    
fi

# Starting OpenAuto
if (whiptail --title "OpenAuto RPi" --yesno "Would you like to start OpenAuto now?" 8 78); then
    /home/pi/openauto/bin/autoapp
else
    
fi
echo "...all done."
