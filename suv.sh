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

function addEnv() {
  echo
  read -p "Enter username: " username
  if [ -z $username ]; then
    echo "Username must not be empty"
    return
  fi

  echo
  read -p "Does this user have home directory? [y/N]: " homeDirExists
  if [ -z $homeDirExists ] || [ $homeDirExists != y ]; then
    echo -e -n "\n Can't add user environment variable to user without home directory"
  else
    cntn=y
    while [ $cntn != N ]
	do
      read -p "Enter VAR_NAME=VALUE: " envVar
	  if [ -z $envVar ]; then
        echo "Environment variable must not be empty"
		return
      fi
	  homedir=$( getent passwd "$username" | cut -d: -f6 )
	  echo -e "\nexport ${envVar}" >> $homedir/.bashrc
      echo -e "variable ${envVar} add to ${username}"
      read -p "Add another variable? [y/N]: " cntn
      if [ -z $cntn ]; then
        cntn=N
      fi
    done
  fi
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
	\r3.add user environment variable
    \r
    \rPlease, choose option [1/2/3], any other key to exit: "

  read mainOption
  
  case $mainOption in
    1)
      createUser
      ;;
    2)
      delUser
      ;;
	3)
      addEnv
      ;;
    *)
      break
      ;;
  esac
done
