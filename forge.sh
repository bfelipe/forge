#!/bin/bash

# OS Essentials
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get dist-upgrade -y
sudo apt-get install build-essential -y

# Misc
sudo apt-get install gnome-tweaks -y
sudo apt-get install totem -y
sudo apt-get install curl -y
sudo apt-get install terminator -y
sudo apt-get install transmission transmission-gtk -y
sudo apt-get install openvpn dialog -y
sudo apt-get install net-tools -y
sudo apt-get install tig -y
sudo apt-get install apt-transport-https -y
sudo apt-get install gnupg ca-certificates -y
sudo apt-get install lsb-core -y
clear

# Git
sudo apt-get install git -y
read -p "Please enter your name for git author: " GIT_USER_NAME
git config --global user.name "\"$GIT_USER_NAME"\"
read -p "Please enter your git email: " GIT_EMAIL
git config --global user.email "\"$GIT_EMAIL"\"
clear

# Development Workspace
set_dev_environment() {
    read -p "Please enter the path directory where your projects will gonna live: " DEV_PATH
    read -p "Please enter the path directory where your third party tools will be installed: " TOOLS_PATH
}

new_dev_env() {
    set_dev_environment
    echo "Your code will gonna be kept at: $DEV_PATH/dev"
    echo "Your tools will gonna be kept at: $TOOLS_PATH/tools"
    read -p "Do you wish to proceed with the creation of these directories (y/n) " DEV_ENV_CHOICE
        if [ $DEV_ENV_CHOICE == "y" ]
        then
            mkdir $DEV_PATH/dev $DEV_PATH/dev/ops
            mkdir $TOOLS_PATH/tools
        elif [ $DEV_ENV_CHOICE == "n" ]
        then
            echo "Aborting dev env creation."
        else
            echo "Invalid option."
            new_dev_env
        fi    
}

new_dev_env
clear

# Microsoft Visual Code
sudo snap install --classic code

# Python Env and Tools
mkdir $DEV_PATH/dev/python
sudo apt-get install python3-pip -y
sudo apt-get install python3-venv -y
sudo apt-get install python3-setuptools -y
sudo apt-get install python-apt python3-apt -y
sed -i "\$a alias python='python3'" ~/.bashrc
sed -i "\$a alias pip='pip3'" ~/.bashrc
source ~/.bashrc
sudo snap install pycharm-community --classic
clear

# Nodejs
mkdir $DEV_PATH/dev/js
read -p "Please enter the Nodejs version you wish to install: " NODE_VER
curl -sL https://deb.nodesource.com/setup_$NODE_VER.x | sudo -E bash -
sudo apt-get update && apt-get install -y nodejs
clear

# Java Env
mkdir $DEV_PATH/dev/java
curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"
sdk version
sdk list java
read -p "Please enter the JDK version you wish to install: " JDK_VER
sdk install java $JDK_VER
sdk install maven
sdk list gradle
read -p "Please enter the Gradle version you wish to install: " GRADLE_VER
sdk install gradle $GRADLE_VER
sudo snap install intellij-idea-community --classic
clear

install_clang() {
    read -p "Do you wish to install clang compiler? (y/n) " CLANG_INSTALL_BOOL
    if [ $CLANG_INSTALL_BOOL == "y" ]
    then
        sudo apt-get install clang -y
    elif [ $CLANG_INSTALL_BOOL == "n" ]
    then
        echo "Aborting Clang installation."
    else
        echo "Invalid option."
        install_clang
    fi
}

# C++ Env
mkdir $DEV_PATH/dev/cpp
install_clang
sudo snap install clion --classic

# CMake
sudo snap install cmake --classic

# Golang Env
mkdir $DEV_PATH/dev/go $DEV_PATH/dev/go/src $DEV_PATH/dev/go/src/github\.com
sudo snap install go --classic
sudo sed -i "\$a export PATH=\$PATH:/snap/go/current/bin" /etc/profile
sudo sed -i "\$a export GOPATH=\$DEV_PATH/dev/go" /etc/profile
sudo snap install goland --classic
clear

install_unity_development_env() {
    read -p "Do you wish to install Unity engine? (y/n) " UNITY_INSTALL_BOOL
    if [ $UNITY_INSTALL_BOOL == "y" ]
    then
        mkdir $DEV_PATH/dev/unity
        mkdir $TOOLS_PATH/tools/unity-hub
        wget -c https://public-cdn.cloud.unity3d.com/hub/prod/UnityHub.AppImage -P $TOOLS_PATH/tools/unity-hub
        chmod +x $TOOLS_PATH/tools/unity-hub/UnityHub.AppImage
    elif [ $UNITY_INSTALL_BOOL == "n" ]
    then
        echo "Aborting Unity installation."
    else
        echo "Invalid option."
        install_unity_development_env
    fi
}

install_dot_net_env() {
    read -p "Do you wish to install .Net Core SDK? (y/n) " NET_INSTALL_BOOL
    if [ $NET_INSTALL_BOOL == "y" ]
    then
        mkdir $DEV_PATH/dev/csharp
        # .Net Core SDK
        # https://docs.microsoft.com/en-us/dotnet/core/install/linux-package-manager-ubuntu-1910 
        # removed -O packages-microsoft-prod.deb
        wget -c https://packages.microsoft.com/config/ubuntu/19.10/packages-microsoft-prod.deb -P /tmp
        sudo dpkg -i /tmp/packages-microsoft-prod.deb
        sudo apt-get update
        sudo dpkg --purge packages-microsoft-prod && sudo dpkg -i /tmp/packages-microsoft-prod.deb
        sudo apt-get update
        sudo apt-get install dotnet-sdk-3.1
        sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
        echo "deb https://download.mono-project.com/repo/ubuntu stable-bionic main" | sudo tee /etc/apt/sources.list.d/mono-official-stable.list
        sudo apt update
        sudo apt install mono-devel -y
        sudo snap install rider --classic
    elif [ $NET_INSTALL_BOOL == "n" ]
    then
        echo "Aborting .Net Core SDK installation."
    else
        echo "Invalid option."
        install_dot_net_env
    fi
}

# dot Net Env
install_dot_net_env
clear

# Game development with Unity
install_unity_development_env

# Google chrome
wget -c https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -P /tmp
sudo dpkg -i /tmp/google-chrome-stable_current_amd64.deb
sudo rm /tmp/google-chrome-stable_current_amd64.deb
sudo apt install --fix-broken -y
sudo apt autoremove -y


# Proton VPN
sudo pip3 install protonvpn-cli

# Postman
sudo snap install postman

# Virtual Box
sudo apt-get install virtualbox virtualbox-ext-pack virtualbox-guest-additions-iso -y
sudo apt-get install virtualbox-dkms virtualbox-guest-dkms -y
sudo adduser $USER vboxusers

# VLC
sudo snap install vlc

#DBeaver
sudo snap install dbeaver-ce
clear

# Serverless Framework
# https://serverless.com
sudo npm install serverless -g
clear

# Amazon CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
aws --version

install_draw_io_tool() {
    read -p "Do you wish to install Draw io tool? (y/n) " DRAW_IO_INSTALL_BOOL
    if [ $DRAW_IO_INSTALL_BOOL == "y" ]
    then
	sudo snap install drawio
    elif [ $DRAW_IO_INSTALL_BOOL == "n" ]
    then
        echo "Aborting Draw IO installation."
    else
        echo "Invalid option."
        install_draw_io_tool
    fi
}

# Draw IO Tool
install_draw_io_tool

# Docker
sudo apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io -y
sudo usermod -aG docker $(whoami)
newgrp docker << GROUP_SUBSHELL

# Docker compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)"\
 -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Redis
docker pull redis
docker run -it -p 6379:6379 --name redis-service -d redis
sudo apt-get install redis-tools -y

# MongoDB
docker pull mongo
docker run -it -p 27017:27017 --name mongo-service -d mongo
sudo apt-get install mongodb-clients -y

# MySQL
docker run -it -p 3360:3360 --name mysql-service -e MYSQL_ROOT_PASSWORD=root -d mysql
sudo apt-get install mysql-client -y
# sudo apt-get install mysql-workbench -y

# RabbitMQ
# default_user: guest default_pass: guest
#https://hub.docker.com/_/rabbitmq
docker run -it -p 5672:5672 -p 15672:15672 -d --name rabbit-service rabbitmq:3-management

#NATS Streaming
#https://hub.docker.com/_/nats-streaming
docker run -it -p 4222:4222 -p 8222:8222 -d --name nats-service nats-streaming

#EMQ
#https://hub.docker.com/r/emqx/emqx
docker run -it --name emqx-service -p 18083:18083 -p 1883:1883 -d emqx/emqx:latest

#Jupyter
#docker run -it -d -p 8888:8888 --name jupyter jupyter/datascience-notebook

# Postgres
docker run --name postgres -p 5432:5432 -e POSTGRES_PASSWORD=admin -d postgres:11.2

# Keycloak
docker run -p 9080:8080 -d --name keycloak jboss/keycloak
docker exec keycloak /opt/jboss/keycloak/bin/add-user-keycloak.sh -u admin -p admin
docker restart keycloak

GROUP_SUBSHELL

# Colour output schema
# https://misc.flogisoft.com/bash/tip_colors_and_formatting
clear
echo -e "\e[93mAll packages has been installed successfully.\e[0m"
echo -e "\e[93mIt is necessary a complete reboot.\e[0m"
echo -e "\e[93mSave everything before proceed.\e[0m"
read -p "Press anything to continue..." REBOOT_INPUT_FASE_I
    case $REBOOT_INPUT_FASE_I in
        * )
            sudo reboot
        ;;
    esac
