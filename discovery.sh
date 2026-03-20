#!/bin/bash

URL="https://raw.githubusercontent.com/socioambiental/domains/main/webapps.txt"

curl -s "$URL" | awk -F',' '
BEGIN { print "{ \"data\": [" }
{
    app=$1
    domain=$2
    has_dev=$3

    # limpa espaços
    gsub(/^[ \t]+|[ \t]+$/, "", app)
    gsub(/^[ \t]+|[ \t]+$/, "", domain)
    gsub(/^[ \t]+|[ \t]+$/, "", has_dev)

    # PROD sempre existe
    printf "{ \"{#APP}\": \"%s\", \"{#ENV}\": \"prod\", \"{#DOMAIN}\": \"%s\", \"{#HOST}\": \"%s\" },\n", app, domain, app

    # DEV só se flag = 1
    if (has_dev == "1") {
        printf "{ \"{#APP}\": \"%s\", \"{#ENV}\": \"dev\", \"{#DOMAIN}\": \"%s\", \"{#HOST}\": \"%s-dev\" },\n", app, domain, app
    }
}
END { print "]}" }
' | sed '$ s/},/}/'