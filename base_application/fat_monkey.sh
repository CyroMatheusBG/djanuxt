#!/bin/bash
RESTORE='\033[0m'
RED='\033[00;31m'
GREEN='\033[00;32m'
YELLOW='\e[0;33m'
readonly root_folder=$(pwd)

function development_help_tools {
    echo -e "${YELLOW}start_denv${RESTORE}             Starts ${GREEN}development environment${RESTORE}\n"
    echo -e "${YELLOW}actvenv${RESTORE}                Create and activate ${GREEN}venv${RESTORE}\n"
    echo -e "${YELLOW}deactvenv${RESTORE}              Deactivate ${GREEN}venv${RESTORE}\n"
    echo -e "${YELLOW}run_django${RESTORE}             Start the ${GREEN}django${RESTORE} server\n"
    echo -e "${YELLOW}run_nuxt${RESTORE}               Start the ${GREEN}nuxt${RESTORE} server\n"
    echo -e "${YELLOW}dk_build${RESTORE}               Builds a ${GREEN}docker image${RESTORE} for this project\n"
    echo -e "${YELLOW}dk_up${RESTORE}                  Starts a dockerized ${GREEN}full development environment${RESTORE}\n"
    echo -e "${YELLOW}dk_pginx${RESTORE}               Starts dockerized ${GREEN}nginx and postgres${RESTORE}\n"
}

function dk_pginx {
    cd $root_file
    docker-compose -f docker/compose/pginx.yaml up
    exitcode=$?
    cd $root_file
    return $exitcode
}

function dk_up {
    cd $root_file
    docker-compose -f docker/compose/denv.yaml up
    exitcode=$?
    cd $root_file
    return $exitcode
}

function dk_build(){
    cd $root_folder
    docker build -t application .
    exitcode=$?
    cd $root_folder
    return $exitcode
}

function run_nuxt(){
    cd ./front
    npm run dev
    exitcode=$?
    cd $root_folder
    return $exitcodecd 
}

function run_django(){
    cd $root_folder
    cd ./app

    python3 ./manage.py collectstatic --noinput
    python3 ./manage.py migrate --noinput
    python3 ./manage.py runserver 0.0.0.0:8000
    exitcode=$?
    cd $root_folder
    return $exitcode
}

function start_denv(){
    cd $root_folder
    create_venv
    w-x_f_req
    create_djanuxt
}

function create_djanuxt(){
    cd $root_folder
    mkdir front
    
    read -p "Digite o nome do app: " app_name
    
    #Create django_project
    cd ./app
    django-admin startproject $app_name .
    django-admin startapp core
    cd ./core
    touch urls.py
    
    cd ../../front

    # #Create nuxt_project
    npx nuxi@latest init $app_name
    cp -a ./$app_name/. ./front/
    rm -r $app_name
    cd ./front
    mkdir pages
    mkdir components
    cd $root_folder
}

function w-x_f_req(){
    mkdir app
    echo '
        Django
        psycopg2-binary
        python-dateutil
        python-dotenv
        coverage
        tblib
        raven
    ' >> ./app/requirements.txt
    pip install -r ./app/requirements.txt
}

function deactvenv(){
    deactivate
}

function actvenv(){
    source venv/bin/activate   
}

function create_venv(){
    mkdir .env_files
    python3 -m venv venv
    actvenv
}


development_help_tools