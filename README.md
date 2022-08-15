# Nginx and utility scripts
[Nginx](https://nginx.org) setup with utility scripts

## Prerequisites
A [certbot](https://certbot.eff.org/) connected external volume, named `certificates`

Refer [here](https://github.com/maxswjeon/certbot-setup) to set up correctly

## How to Deploy
1. Run bootstrap script
  ```bash
  ./bootstrap.sh DEFAULT_HOST
  ```
  > **Warning**  
  > `bootstrap.sh` must be run in the directory that `docker-compose.yml` is located, since it uses `pwd` to check current directory and set as prefix to utility scripts

2. `docker compose up -d` or `docker-compose up -d` to deploy

## Utility Scripts
### `nginx_genconf`
Generates nginx configuration files

#### Usage
##### Generating Reverse Proxy Configuration files
```bash
scripts/nginx_genconf proxy DOMAIN [HOST] PORT
```

##### Generating SSL Configuration files
```bash
scripts/nginx_genconf ssl DOMAIN
```

To work correctly, certificate for `DOMAIN` must be generated beforehand.  
To generate certificate, refer [here](https://github.com/maxswjeon/certbot-setup)

### `nginx_enable`
Enables generated configuration files (creates a symbolic link from `sites-available` to `sites-enabled`)

#### Usage
```bash
scripts/nginx_enable DOMAIN
```

### `nginx_disable`
Disables enabled configuration files (deletes the symbolic link in `sites-enabled`)

#### Usage
```bash
scripts/nginx_disable DOMAIN
```

### `nginx_test`
Tests nginx configuration files

#### Usage
```bash
scripts/nginx_test
```

### `nginx_reload`
Reloads nginx configuration gracefully using SIGHUP singal (minimal downtime)  

#### Usage
```bash
scripts/nginx_reload
```

