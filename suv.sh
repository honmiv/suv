#!/bin/bash

function createUser() {
	
	echo
	read -p "What user you want to create? Enter its name: " username
	
	if [ -z $username ]; then
		echo -e -n "\nUsername must not be empty"
		return
	fi
	
	echo 
	read -p "With its home directory? [Y/n]: " createWithHomeDirectory
	withDir=""
	homeDir=""
	if [ -z $createWithHomeDirectory ] || [ $createWithHomeDirectory != n ]; then
		withDir="-m"
		echo 
		read -p "Enter home directory path: " homeDir
		if [ -z $homeDir ]; then
			echo -e -n "\nHome directory must not be empty"
			return
		fi
		homeDir="-d ${homeDir}"
	fi
	
	useradd -s $SHELL $withDir $homeDir $username
	
	echo
	read -p "Set password for ${username}? [Y/n]: " setPassword
	if [ $setPassword != n ]; then
		echo
		passwd $username
		echo
	fi
}

function delUser() {
	echo -e -n "\nWhich user you want to delete? Enter its name: "
	read username
	echo -e -n "\nWith its home directory? [Y/n]: "
	read delWithHomeDirectory
	withDir="-r"
	if [ $delWithHomeDirectory = n ] 
	then
		withDir=""
	fi
	echo
	userdel $withDir $username
	echo
}

if [ `whoami` != 'root' ]; then
    echo "You must be root to use this manager."
    exit
fi

echo "Welcome to SimpleUserManager [SUV]"

while :
do
	echo -e -n "
		\rYou can:
		\r
		\r1.create user
		\r2.delete user
		\r
		\rPlease, choose option [1/2], any other key to exit: "

	read mainOption
	
	case $mainOption in
		1)
			createUser
			;;
		2)
			delUser
			;;
		*)
			break
			;;
	esac
done
