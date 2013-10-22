#!/bin/bash 
function prompt_yes_no {
    while true; do
    read -p "$@ " yn
    case $yn in
        [Yy]* ) let yesno_val=1; return;;
        [Nn]* ) let yesno_val=0; return;;
        * ) echo "Please answer yes or no. ";;
    esac
done
}

function prompt {
    read -p "$@ " prompt_val
}

function setup {
    prompt "Please enter your email"
    email="$prompt_val"
    prompt "Please enter your github username"
    username="$prompt_val"
    prompt "Please enter your heroku app name (ex http://MY-APP.herokuapp.com)"
    appname="$prompt_val"
   
    echo "Your email is $email"
    echo "Your username is $username"
    echo "Your website will be http://$appname.herokuapp.com"
    
    prompt_yes_no "Continue? " 
    if [ $yesno_val -eq 1 ] 
    then
		touch ~/.bashrc
		echo "export HTTP_PROXY='http://proxy:8002'" >> ~/.bashrc
		export HTTP_PROXY='http://proxy:8002'
		
        git config --global user.email $email
        git config --global user.name $username
		git config --global http.proxy proxy:8002
		
		touch index.php
        echo "<?php include_once('index.html'); ?>" > index.php

        git init
        git remote add origin https://github.com/$username/ScriptEd
        git config credential.helper store
        git add -A
        git commit -m "saving"
        git push origin master
        
        heroku login
        heroku apps:create $appname
        git push heroku master
        
        
        
        echo "ScriptEd initialized successfully!  You can now save and deploy your files"

    fi
}


prompt_yes_no "This will initialize ScriptEd in this directory.  Before continuing, you should sign up for GitHub and Heroku, and create a repository on GitHub called 'ScriptEd'.  Do you wish to continue?"
if [ $yesno_val -eq 1 ] 
then
    
  setup
fi