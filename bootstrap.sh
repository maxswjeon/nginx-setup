#!/bin/bash

if [ "$#" -ne 1 ]; then
	echo "Default Host not given"
	echo "usage: bootstrap.sh DEFAULT_HOST"
	exit 1
fi

PREFIX="$(pwd | sed 's/\//\\\//g')"
DEFAULT_HOST="$1"

echo "Copying scripts"

if [ ! -d scripts ]; then
	mkdir scripts
fi

cp -a templates/scripts/* scripts/

sed -i "s/{{ PREFIX }}/${PREFIX}/g" scripts/nginx_genconf
sed -i "s/{{ PREFIX }}/${PREFIX}/g" scripts/nginx_enable
sed -i "s/{{ PREFIX }}/${PREFIX}/g" scripts/nginx_disable
sed -i "s/{{ PREFIX }}/${PREFIX}/g" scripts/nginx_list

if [ ! -f dhparam ]; then
	echo "Creating dhparam"
	openssl dhparam -out dhparam 4096
else
	echo "Using existing dhparam"
fi

echo "Creating default host"

if [ ! -d snippets/ssl ]; then
	mkdir snippets/ssl
fi

scripts/nginx_genconf ssl "${DEFAULT_HOST}"

cp templates/nginx.conf nginx.conf
sed -i "s/{{ DEFAULT_HOST }}/${DEFAULT_HOST}/g" nginx.conf

if [ ! -d sites-available ]; then
	mkdir sites-available
fi

if [ ! -d sites-enabled ]; then
	mkdir sites-enabled
fi
