#!/bin/bash

URL="https://raw.githubusercontent.com/socioambiental/domains/main/webapps.txt"

echo '{ "data": ['

first=1

while IFS=',' read -r app domain has_dev; do
    # limpa espaços
    app=$(echo "$app" | xargs)
    domain=$(echo "$domain" | xargs)
    has_dev=$(echo "$has_dev" | xargs)

    # PROD
    if [ $first -eq 0 ]; then echo ","; fi
    echo -n "{ \"{#APP}\": \"$app\", \"{#ENV}\": \"prod\", \"{#DOMAIN}\": \"$domain\", \"{#HOST}\": \"$app\" }"
    first=0

    # DEV (se flag)
    if [ "$has_dev" = "1" ]; then
        echo ","
        echo -n "{ \"{#APP}\": \"$app\", \"{#ENV}\": \"dev\", \"{#DOMAIN}\": \"$domain\", \"{#HOST}\": \"$app-dev\" }"
    fi

done < <(curl -s "$URL")

echo '] }'