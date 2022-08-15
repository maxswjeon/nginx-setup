#!/bin/bash

if [ -f .env ]; then
	source .env
fi

if [ -z "$PREFIX" ]; then
	echo "Failed to get PREFIX"
	exit 1
fi

if [ -z "$DEFAULT_HOST" ]; then
	echo "Failed to get DEFAULT_HOST"
	exit 2
fi

echo "Copying scripts"

if [ ! -d scripts ]; then
	mkdir scripts
fi

cp -a templates/scripts/* scripts/

sed -i "s/{{ PREFIX }}/${PREFIX}/g" scripts/nginx_genconf
sed -i "s/{{ PREFIX }}/${PREFIX}/g" scripts/nginx_enable
sed -i "s/{{ PREFIX }}/${PREFIX}/g" scripts/nginx_disable

if [ ! -f dhparam ]; then
	echo "Creating dhparam"
	openssl dhparam -out dhparam 4096
else
	echo "Using existing dhparam"
fi

echo "Creating default host"
scripts/nginx_genconf ssl "${DEFAULT_HOST}"

cp templates/nginx.conf nginx.conf
sed -i "s/{{ DEFAULT_HOST }}/${DEFAULT_HOST}/g" nginx.conf

if [ ! -d snippets/ssl ]; then
	mkdir snippets/ssl
fi


