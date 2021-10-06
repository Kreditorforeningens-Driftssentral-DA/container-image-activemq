# ACTIVEMQ
![Public Image Builds](https://github.com/Kreditorforeningens-Driftssentral-DA/container-image-activemq/workflows/Packer%20Public/badge.svg?branch=main)

Container image for ActiveMQ (Classic) | See on [Docker Hub](https://hub.docker.com/r/kdsda/activemq)

## HOW TO USE THIS IMAGE
This image will start an activemq instance

```bash
# Using docker-compose in example/ folder
cd example
docker-compose up

# Running standalone
docker run --rm -it -p 8161:8161 kdsda/activemq:latest
```

#### DEFAULT CREDENTIALS
Default credentials (web/queue):
  * Username: system
  * Password: manager

## CUSTOMIZATION
The container supports the following customization before startup

#### ADMIN USER
| Environment            | Type   | Default           | Description              |
|------------------------|-------:|:------------------|--------------------------|
| ACTIVEMQ_USERNAME      | string | system            ||
| ACTIVEMQ_USERNAME      | string | manager           ||
| POSTGRES_ENABLED       | bool   | false             | Use postgres persistence backend |
| POSTGRES_HOST          | string | postgres          ||
| POSTGRES_PORT          | int    | 5432              ||
| POSTGRES_DATABASE      | string | postgres          ||
| POSTGRES_USERNAME      | string | postgres          ||
| POSTGRES_PASSWORD      | string | postgres          ||
| POSTGRES_INIT          | bool   | false             | Initialize database on startup | 
| POSTGRES_CONN_INIT     | int    | 2                 ||
| POSTGRES_CONN_IDLE     | int    | 4                 ||
| POSTGRES_CONN_MAX      | int    | 8                 ||
| HAWTIO_ENABLED         | bool   | false             | Set 'true' to enable HawtIO (:8161/hawtio) |
| LOG4J_LOGLEVEL         | string | INFO              ||
| LOG4J_LOGFILE          | string | /tmp/amq.log      ||
| STOMP_ENABLED          | bool   | false             ||
| AMPQ_ENABLED           | bool   | false             ||
| MQTT_ENABLED           | bool   | false             ||
| WS_ENABLED             | bool   | false             || 
| OPENWIRE_ENABLED       | bool   | true              ||
| OPENWIRE_MAXINACTIVITY | int    | 0                 ||
| OPENWIRE_MAXCONN       | int    | 1000              ||
| OPENWIRE_MAXFRAMESIZE  | int    | 1048576000        ||
| AUTH_ENABLED           | boot   | true              | Set 'false' to disable authentication |

## LINKS
  * https://activemq.apache.org/web-console
  * https://j2live.ttl255.com/