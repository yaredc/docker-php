# DOCKER DEV ENVIRONMENT 

## RUN A COMMAND

```bash
docker-compose (run|exec) php composer install
docker-compose (run|exec) node npm install
docker-compose (run|exec) php /bin/bash
docker-compose (run|exec) [CONATINER-AS-DEFINED-IN-YAML] [COMMAND]
```

## SOME HANDY DOCKER COMMANDS

```bash
docker-compose build --no-cache
docker-compose up -d
docker-compose ps
docker-compose down

docker container ls -aq | xargs docker container stop
docker container ls -aq | xargs docker container rm
docker image ls -aq | xargs docker image rm -f
docker volume ls -q | xargs docker volume rm -f

#REMOVE EVERYTHING. INCLUDING VOLUMES!
docker container ls -aq | xargs docker container stop && docker container ls -aq | xargs docker container rm && docker image ls -aq | xargs docker image rm -f && docker volume ls -q | xargs docker volume rm -f

sysctl vm.max_map_count           #SEE HOW MUCH MEMORY YOU ALLOW FOR VIRTUAL MACHINES
sysctl -w vm.max_map_count=262144 #ALLOW THIS MUCH MEMORY FOR YOUR VM-S. CAREFUL WITH THIS ONE!

ip addr show [INTERFACE] #GET IP FOR XDEBUG. PASS IT TO XDEBUG_CONFIG IN docker-compose.yaml
ip addr show wlp2s0
```

## PHPSTORM AND PHP APP CONFIG

Set up your paths correctly in `File | Settings | Languages & Frameworks | PHP | Servers`. Setting only project root folder mapping should be enough.

Normally, as PHP interpreter, set `Docker compose` and as `Service` select `php`. PhpStorm should automatically recognize everything else.

To access other containers from some container itself, you should use container names as defined in YAML for hostname. For example, here is a sample [Doctrine](https://www.doctrine-project.org/index.html) config:

```php
<?php

declare(strict_types=1);

return [
    'doctrine' => [
        'paths' => [dirname(__DIR__, 2) . '/src/Common/src/Entity'],
        'isDevMode' => false,
        'proxyDir' => dirname(__DIR__, 2) . '/data',
        'connection' => [
            'driver' => 'pdo_pgsql',
            'host' => 'pgsql',
            'port' => 5432,
            'dbname' => 'root',
            'user' => 'root',
            'password' => 'root'
        ]
    ]
];
```

Note the `host` value. This should be automatically connected/linked by `docker-compose` itself.

## DATABASE DATA SHARING

Please use following (or similar) setup for having PostgreSQL data in separate folder (note `volumes` part):

```yaml
  pgsql:
    depends_on:
      - nginx
    image: postgres:11.2-alpine
    volumes:
      - ./pgsql:/var/lib/postgresql/data
    environment:
      POSTGRES_USER: root
      POSTGRES_PASSWORD: root
      POSTGRES_DB: root
    ports:
      - 5432:5432
```

For more info, please go [here](https://hub.docker.com/_/postgres/) under "Where to Store Data" section.

## USEFUL LINKS

- [Zend Expressive](https://docs.zendframework.com/zend-expressive/)
- [nginx sample configurations](https://www.nginx.com/resources/wiki/start/topics/examples/full/)
- [PHP Docker](https://hub.docker.com/_/php/)
