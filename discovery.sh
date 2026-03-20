#!/bin/bash

NOW=$(date +%s)
URL="https://raw.githubusercontent.com/socioambiental/domains/main/webapps.txt?nocache=$NOW"

echo '{ "data": ['

first=1

curl -s "$URL" | sed '/^\s*$/d' | while IFS=',' read -r app domain has_dev || [ -n "$app" ]; do

    case "$app" in
        \#*) continue ;;
    esac

    app=$(echo "$app" | xargs)
    domain=$(echo "$domain" | xargs)
    has_dev=$(echo "$has_dev" | xargs)

    [ -z "$app" ] && continue
    [ -z "$domain" ] && continue
    [ -z "$has_dev" ] && has_dev="0"

    # 🔥 correção definitiva do domínio
    dot_count=$(echo "$domain" | awk -F'.' '{print NF-1}')

    if [ "$dot_count" -ge 2 ]; then
        domain_base=$(echo "$domain" | cut -d'.' -f2-)
    else
        domain_base="$domain"
    fi

    # ---- PROD ----
    if [ $first -eq 0 ]; then echo ","; fi

    echo -n "{ \"{#APP}\": \"$app\", \"{#ENV}\": \"prod\", \"{#DOMAIN}\": \"$domain_base\", \"{#HOST}\": \"$app\" }"

    first=0

    # ---- DEV ----
    if [ "$has_dev" = "1" ]; then
        echo ","
        echo -n "{ \"{#APP}\": \"$app\", \"{#ENV}\": \"dev\", \"{#DOMAIN}\": \"$domain_base\", \"{#HOST}\": \"$app-dev\" }"
    fi

done

echo '] }'