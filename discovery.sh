#!/bin/bash

FILE="./webapps.txt"

echo '{ "data": ['

FIRST=1

while IFS=',' read -r app env timeout; do
    # ignora linhas vazias ou comentários
    [[ -z "$app" || "$app" =~ ^# ]] && continue

    # defaults
    [ -z "$env" ] && env="prod"
    [ -z "$timeout" ] && timeout="3"

    if [ $FIRST -eq 0 ]; then
        echo ","
    fi

    echo -n "  { \"{#APP}\": \"$app\", \"{#ENV}\": \"$env\", \"{#TIMEOUT}\": \"$timeout\" }"

    FIRST=0
done < $FILE

echo
echo "]}"