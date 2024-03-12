#!/bin/bash

# OS Essentials
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get dist-upgrade -y
sudo apt-get install build-essential -y

# Few extra packages and tools 
sudo apt-get install gnome-tweaks -y
sudo apt-get install tmux -y
sudo apt-get install totem -y
sudo apt-get install curl -y
sudo apt-get install transmission transmission-gtk -y
sudo apt-get install openvpn dialog -y
sudo apt-get install net-tools -y
sudo apt-get install tig -y
sudo apt-get install apt-transport-https -y
sudo apt-get install gnupg ca-certificates -y
sudo apt-get install gnupg-agent software-properties-common -y
sudo apt-get install lsb-core -y
sudo apt-get install libfuse2 -y
sudo apt-get install xclip xsel -y
sudo apt-get install git -y
clear

# Nvim
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod +x nvim.appimage
./nvim.appimage --appimage-extract
./squashfs-root/AppRun --version
sudo mv squashfs-root /
sudo ln -s /squashfs-root/AppRun /usr/bin/nvim
mkdir ~/.config/nvim
rm nvim.appimage && rm -r squashfs-root

# Cauldron
git clone https://gitlab.com/bfelipe/cauldron.git
source /cauldron/simple-install.sh
sudo rm -r /cauldron
clear

# Tmux
mkdir ~/.config/tmux
cp tmux.conf ~/.config/tmux
mkdir ~/.tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
source ~/.config/tmux/tmux.conf
clear


# Git Setup
read -p "Inform git author's name: " GIT_USER_NAME
git config --global user.name "\"$GIT_USER_NAME"\"
read -p "Inform author email: " GIT_EMAIL
git config --global user.email "\"$GIT_EMAIL"\"
git config --global init.defaultBranch main
# Generating ssh key pair
echo -e "\e[93mGenerating SSH Key...\e[0m"
ssh-keygen -t ed25519 -C "$GIT_EMAIL"
ssh-add /home/$(whoami)/.ssh/id_ed25519
clear


# Setup Firewall
# https://help.ubuntu.com/community/UFW
sudo apt-get install gufw -y
sudo ufw enable
sudo ufw status verbose

# Enable Airpod detection
sudo sed -i '/#ControllerMode = dual/c\ControllerMode = bredr' /etc/bluetooth/main.conf
sudo /etc/init.d/bluetooth restart

read -p "Inform full path for your projects without the last /: " DEV_PATH
echo "Creating projects directory at: $DEV_PATH/dev"
mkdir $DEV_PATH/dev $DEV_PATH/dev/ops
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

# C++ Env
echo "Installing clang compiler and cmake..."
mkdir $DEV_PATH/dev/cpp $DEV_PATH/dev/c
sudo apt-get install clang -y
clear

# Bazel Env
install_bazel() {
    read -p "Do you wish to install Bazel? (y/n) " BAZEL_INSTALL_BOOL
    if [ $BAZEL_INSTALL_BOOL == "y" ]
    then
        sudo apt install apt-transport-https curl gnupg -y
        curl -fsSL https://bazel.build/bazel-release.pub.gpg | gpg --dearmor >bazel-archive-keyring.gpg
        sudo mv bazel-archive-keyring.gpg /usr/share/keyrings
        echo "deb [arch=amd64 signed-by=/usr/share/keyrings/bazel-archive-keyring.gpg] https://storage.googleapis.com/bazel-apt stable jdk1.8" | sudo tee /etc/apt/sources.list.d/bazel.list
        sudo apt update && sudo apt install bazel -y
        bazel --version
    elif [ $BAZEL_INSTALL_BOOL == "n" ]
    then
        echo "Aborting Bazel installation."
    else
        echo "Invalid option."
        install_bazel
    fi
}

install_bazel
clear

# Golang Env
install_go() {
    read -p "Do you wish to install go compiler? (y/n) " GO_INSTALL_BOOL
    if [ $GO_INSTALL_BOOL == "y" ]
    then
        mkdir $HOME/go $HOME/go/src $HOME/go/bin
        read -p "Please enter the Go version you wish to install: " GO_VER
        wget -c "https://go.dev/dl/go$GO_VER.linux-amd64.tar.gz" -P /tmp
        sudo tar -C /usr/local -xzf /tmp/go$GO_VER.linux-amd64.tar.gz
        sudo sed -i "\$a export GOPATH=$HOME/go" /etc/profile
        sudo sed -i "\$a export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" /etc/profile
        sudo rm /tmp/go$GO_VER.linux-amd64.tar.gz
	source /etc/profile
	go version
        go install github.com/go-delve/delve/cmd/dlv@latest
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

# GRPC tools
sudo apt install -y protobuf-compiler
protoc --version
go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
go install github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-grpc-gateway@latest
go install github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-openapiv2@latest
go install github.com/fullstorydev/grpcurl/cmd/grpcurl@latest

# Rust ENV
install_rust() {
    read -p "Do you wish to install rust tooling? (y/n)" RUST_INSTALL_BOOL
    if [ $RUST_INSTALL_BOOL == "y" ]
    then
        mkdir $DEV_PATH/dev/rust
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
        rustc --version
    elif [ $RUST_INSTALL_BOOL == "n" ]
    then
        echo "Aborting Rust installation."
    else
        echo "Invalid option."
        install_rust
    fi
}

install_rust
clear

# Virtual Box
sudo apt-get install virtualbox virtualbox-ext-pack virtualbox-guest-additions-iso -y
sudo apt-get install virtualbox-dkms -y
sudo adduser $USER vboxusers
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
