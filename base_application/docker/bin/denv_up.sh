#!/bin/bash
#sleep 999999

./manage.py collectstatic --noinput
,/manage.py makemigration --noinput
,/manage.py migrate --noinput
cd ./application
./manage.py runserver 0.0.0.0:8000 & cd /application/front
npm run dev
