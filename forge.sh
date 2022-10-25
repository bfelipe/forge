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
            mkdir $DEV_PATH/dev
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
        sudo snap install pycharm-community --classic
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


# Serverless Framework
# https://serverless.com
install_serverless() {
    read -p "Do you wish to install serverless? (y/n) " SERVERLESS_INSTALL_BOOL
    if [ $SERVERLESS_INSTALL_BOOL == "y" ]
    then
        sudo npm install serverless -g
    elif [ $SERVERLESS_INSTALL_BOOL == "n" ]
    then
        echo "Aborting serverless installation."
    else
        echo "Invalid option."
        install_serverless
    fi
}

# Nodejs
install_nodejs() {
    read -p "Do you wish to install node js? (y/n) " NODE_INSTALL_BOOL
    if [ $NODE_INSTALL_BOOL == "y" ]
    then
        mkdir $DEV_PATH/dev/js
        read -p "Please enter the Nodejs version you wish to install: " NODE_VER
        curl -sL https://deb.nodesource.com/setup_$NODE_VER.x | sudo -E bash -
        sudo apt-get update && apt-get install -y nodejs
        install_serverless
    elif [ $NODE_INSTALL_BOOL == "n" ]
    then
        echo "Aborting node js installation."
    else
        echo "Invalid option."
        install_nodejs
    fi
}

install_nodejs
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
        sdk list kotlin
        read -p "Please enter the Kotlin version you wish to install: " KOTLIN_VER
        sdk install kotlin $KOTLIN_VER
        sudo snap install intellij-idea-community --classic
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
install_clang() {
    read -p "Do you wish to install clang compiler? (y/n) " CLANG_INSTALL_BOOL
    if [ $CLANG_INSTALL_BOOL == "y" ]
    then
        mkdir $DEV_PATH/dev/cpp
        sudo snap install cmake --classic
        sudo apt-get install clang -y
    elif [ $CLANG_INSTALL_BOOL == "n" ]
    then
        echo "Aborting Clang installation."
    else
        echo "Invalid option."
        install_clang
    fi
}

install_clang
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

# Postman
sudo snap install postman

# Virtual Box
sudo apt-get install virtualbox virtualbox-ext-pack virtualbox-guest-additions-iso -y
sudo apt-get install virtualbox-dkms virtualbox-guest-dkms -y
sudo adduser $USER vboxusers

#DBeaver
sudo snap install dbeaver-ce

#Drawio tool
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

install_draw_io_tool
clear

# OBS Studio
sudo snap install obs-studio
clear

# Docker
sudo apt install --fix-broken -y
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
read -p "What version of docker-compose do you like to install? (y/n) " COMPOSE_VER
sudo mkdir /usr/local/bin
sudo curl -L "https://github.com/docker/compose/releases/download/$COMPOSE_VER/docker-compose-linux-amd64"\
-o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Redis
docker pull redis
docker run -it -p 6379:6379 --name redis-service -d redis
sudo apt-get install redis-tools -y

# MongoDB
docker pull mongo
docker run -it -p 27017:27017 --name mongo-service -d mongo

# Postgres
read -p "What version of postgres do you like to install? (y/n) " POSTGRES_VER
docker run --name postgres -p 5432:5432 -e POSTGRES_PASSWORD=admin -d postgres:$POSTGRES_VER

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
