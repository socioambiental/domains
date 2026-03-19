#!/bin/bash

FILE="./webapps.txt"

echo '{ "data": ['

FIRST=1

while read app; do
    # ignora linhas vazias
    [ -z "$app" ] && continue

    if [ $FIRST -eq 0 ]; then
        echo ","
    fi

    echo -n "  { \"{#APP}\": \"$app\" }"
    FIRST=0
done < $FILE

echo
echo "]}"