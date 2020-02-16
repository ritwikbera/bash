#!/bin/bash

echo -n "Enter virtual environment name"
read venvname

check_package_installed(){
	PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $1|grep "install ok installed")
	if [[ $PKG_OK == "install ok installed" ]];
	then
		echo "true"
	else
		echo "false"
	fi
}

if [[ $(check_package_installed sublime-text) == "true" ]];
then
	echo "Sublime installed"
else
	echo "Installing sublimetext"
	wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
	sudo apt-get install apt-transport-https
	echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
	sudo apt update
	sudo apt install sublime-text
fi 

if [[ $(check_package_installed git) == "true" ]];
then
	echo "git installed"
else
	echo "Installing git"
	sudo apt install git
fi

sudo apt install python3-venv

if [[ -d ~/virtual-envs ]];
then
	echo "virtual-envs directory already made"
else
	mkdir virtual-envs
fi

if [[ -d ~/virtual-envs/$venvname ]];
then
	echo "$venvname already exists"
else
	cd ~/virtual-envs
	python3 -m venv $venvname
fi


SET_ALIAS="alias pytorch='source ~/virtual-envs/$venvname/bin/activate'"
ALIAS_SET="false"

# here string used to make while loop run in same subshell
while read line; do
	if [[ $line == *$SET_ALIAS* ]];
	then
		echo "alias set"
		ALIAS_SET="true"
		break
	fi
done <<< "$(cat ~/.bashrc)"

if [[ $ALIAS_SET == "false" ]];
then
	echo "Setting up alias in .bashrc"
	echo -e "\n$SET_ALIAS">>~/.bashrc
fi

# grep -q 'source ~/virtual-envs/$venvname/bin/activate' ~/.bashrc
# if [[ $? != 0 ]]; then
# 	echo "Setting up alias in .bashrc"
# 	echo $SET_ALIAS>>~/.bashrc
# fi

# activate pytorch virtual env
source ~/virtual-envs/$venvname/bin/activate && pip3 install -r ~/requirements.txt && echo "Environment setup complete. Enter pytorch to activate virtual env."
