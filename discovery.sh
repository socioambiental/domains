#!/bin/bash

# cache buster seguro
NOW=$(date +%s)
URL="https://raw.githubusercontent.com/socioambiental/domains/main/webapps.txt?nocache=$NOW"

# valida URL
if [ -z "$URL" ]; then
  echo '{ "data": [] }'
  exit 1
fi

echo '{ "data": ['

first=1

curl -s "$URL" | sed '/^\s*$/d' | while IFS=',' read -r app domain has_dev || [ -n "$app" ]; do

    # ignora comentários
    case "$app" in
        \#*) continue ;;
    esac

    # trim seguro
    app=$(echo "$app" | xargs)
    domain=$(echo "$domain" | xargs)
    has_dev=$(echo "$has_dev" | xargs)

    # validação mínima
    [ -z "$app" ] && continue
    [ -z "$domain" ] && continue

    # default flag
    [ -z "$has_dev" ] && has_dev="0"

    # ---- PROD ----
    if [ $first -eq 0 ]; then echo ","; fi

    echo -n "{ \"{#APP}\": \"$app\", \"{#ENV}\": \"prod\", \"{#DOMAIN}\": \"$domain\", \"{#HOST}\": \"$app\" }"

    first=0

    # ---- DEV ----
    if [ "$has_dev" = "1" ]; then
        echo ","
        echo -n "{ \"{#APP}\": \"$app\", \"{#ENV}\": \"dev\", \"{#DOMAIN}\": \"$domain\", \"{#HOST}\": \"$app-dev\" }"
    fi

done

echo '] }'