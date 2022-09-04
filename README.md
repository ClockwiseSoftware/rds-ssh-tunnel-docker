## SSH tunnel docker container for AWS RDS postgres database

The aim of this repo is to show an example of docker container and docker compose file to provide SSH tunnel to your AWS RDS database.

With this config you can get a container to connect your aws RDS database.

Also, container has postgres client installed, and you can do backups or the other maintenance tasks.


### Using DEV database proxy
- You should have ssh key for your bastion server, for example `aws_bastion_rsa` key file in your user `~/.ssh` directory
- Copy `docker-compose-db-proxy.yml` and set up environment section specific for you:
  
  - BASTION_IP - It's usually your dev server IP
  - BASTION_USER - user to connect bastion server via ssh, usually `ec2-user` for amazon linux
  - BASTION_SSH_KEY - you ssh key file name `aws_bastion_rsa`
  - SOURCE_DOMAIN_OR_IP - you RDS postgres server domain
  - ALIVE_INTERVAL - (default 60) ServerAliveInterval option https://man.openbsd.org/ssh_config.5#ServerAliveInterval
  - ALIVE_COUNT_MAX - (default 10) ServerAliveCountMax https://man.openbsd.org/ssh_config.5#ServerAliveCountMax

Docker compose sample:
```yaml
version: '3'
services:
  db-proxy:
    image: ghcr.io/clockwisesoftware/rds-ssh-tunnel-docker:master
    environment:
      BASTION_IP: 1.1.1.153
      BASTION_USER: ec2-user
      BASTION_SSH_KEY: aws_bastion_rsa
      SOURCE_DOMAIN_OR_IP: my-postgres-db.us-west-2.rds.amazonaws.com
      SOURCE_PORT: 5432
      CONTAINER_PORT: 54324
    volumes:
      - ~/.ssh:/home/node/.ssh
    ports:
      - '54324:54324'
```

```shell
docker-compose -f docker-compose-db-proxy.yml up
```
Database should be accessible from your host machine as localhost:54324 and in docker container as db-proxy:54324


You can make a dump of DEV database:

without logging to container's shell, just from your local console

```shell
docker-compose -f docker-compose-db-proxy.yml exec db-proxy pg_dump -h localhost -p 54324 -U api_dev -f dump.sql databasename_dev
```

or log into a container shell run pg_dump like below and paste postgres user's password

```shell
docker-compose -f docker-compose-db-proxy.yml exec db-proxy bash
pg_dump -h localhost -p 54323 -U postgres -f dump.sql databasename_dev
```


### Bastion keep connection alive config

- Configuring the sshd part on the server.

`/etc/ssh/sshd_config`

```shell
ClientAliveInterval 60
TCPKeepAlive yes
ClientAliveCountMax 10000
```

- Restart the ssh server

service `ssh restart` or  `service sshd restart` depending on what system you are on.