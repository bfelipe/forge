#!/bin/bash

# OS Essentials
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get dist-upgrade -y
sudo apt-get install build-essential -y

# Few extra packages and tools 
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
sudo apt-get install gnupg-agent software-properties-common -y
sudo apt-get install lsb-core -y
clear

# Git
sudo apt-get install git -y
read -p "Inform git author's name: " GIT_USER_NAME
git config --global user.name "\"$GIT_USER_NAME"\"
read -p "Inform author email: " GIT_EMAIL
git config --global user.email "\"$GIT_EMAIL"\"
# Generatin ssh key pair
echo -e "\e[93mGenerating SSH Key...\e[0m"
ssh-keygen -t ed25519 -C "$GIT_EMAIL"
ssh-add /home/$(whoami)/.ssh/id_ed25519
clear


read -p "Inform full path for your projects: " DEV_PATH
echo "Creating projects directory at: $DEV_PATH/dev"
echo "Creating tools directory at: $DEV_PATH/tools"
mkdir $DEV_PATH/dev $DEV_PATH/tools
clear

# Python Env and Tools
install_python_tools() {
    read -p "Do you wish to install python additional tools? (y/n) " PYTHON_INSTALL_BOOL
    if [ $PYTHON_INSTALL_BOOL == "y" ]
    then
        mkdir $DEV_PATH/dev/python
        sudo apt-get install python3-pip -y
        sudo apt-get install python3-venv -y
        sudo apt-get install python3-setuptools -y
        sudo apt-get install python3-apt -y
        sed -i "\$a alias python='python3'" ~/.bashrc
        sed -i "\$a alias pip='pip3'" ~/.bashrc
        source ~/.bashrc
    elif [ $PYTHON_INSTALL_BOOL == "n" ]
    then
        echo "Aborting python tools installation."
    else
        echo "Invalid option."
        install_python_tools
    fi
}

install_python_tools
clear

# Java Env
install_java_env() {
    read -p "Do you wish to install java environment? (y/n) " JAVA_INSTALL_BOOL
    if [ $JAVA_INSTALL_BOOL == "y" ]
    then
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
    elif [ $JAVA_INSTALL_BOOL == "n" ]
    then
        echo "Aborting java installation."
    else
        echo "Invalid option."
        install_java_env
    fi
}

install_java_env
clear

# C++ Env
echo "Installing clang compiler and cmake..."
mkdir $DEV_PATH/dev/cpp $DEV_PATH/dev/c
sudo snap install cmake --classic
sudo apt-get install clang -y
clear

# Golang Env
install_go() {
    read -p "Do you wish to install go compiler? (y/n) " GO_INSTALL_BOOL
    if [ $GO_INSTALL_BOOL == "y" ]
    then
        mkdir $DEV_PATH/dev/go
        read -p "Please enter the Go version you wish to install: " GO_VER
        wget -c "https://golang.google.cn/dl/go$GO_VER.linux-amd64.tar.gz" -P /tmp
        sudo tar -C /usr/local -xzf /tmp/go$GO_VER.linux-amd64.tar.gz
        sudo sed -i "\$a export PATH=\$PATH:/usr/local/go/bin" /etc/profile
        sudo rm /tmp/go$GO_VER.linux-amd64.tar.gz
        $(go version)
    elif [ $GO_INSTALL_BOOL == "n" ]
    then
        echo "Aborting Go installation."
    else
        echo "Invalid option."
        install_go
    fi
}

install_go
clear

# Google chrome
wget -c https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -P /tmp
sudo dpkg -i /tmp/google-chrome-stable_current_amd64.deb
sudo rm /tmp/google-chrome-stable_current_amd64.deb
sudo apt install --fix-broken -y
sudo apt autoremove -y
clear

# Virtual Box
sudo apt-get install virtualbox virtualbox-ext-pack virtualbox-guest-additions-iso -y
sudo apt-get install virtualbox-dkms -y
sudo adduser $USER vboxusers

# Postman - DBeaver - Drawio tool - krita - code
sudo snap install postman
sudo snap install dbeaver-ce
sudo snap install drawio
sudo snap install krita
sudo snap install --classic code
clear

# Docker
sudo apt update
sudo apt install --fix-broken -y
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
sudo groupadd docker
sudo usermod -aG docker $(whoami)
newgrp docker << GROUP_SUBSHELL

# Redis
docker pull redis
docker run -it -p 6379:6379 --name redis-service -d redis
sudo apt-get install redis-tools -y

# MongoDB
docker pull mongo
docker run -it -p 27017:27017 --name mongo-service -d mongo

# Postgres
docker run --name postgres-service -p 5432:5432 -e POSTGRES_PASSWORD=admin -d postgres:latest

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
