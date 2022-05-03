# CONTAINER-IMAGE-ACTIVEMQ

#### References

* https://activemq.apache.org/components/classic/documentation

## Image variables

| Name | Default | Description |
| :-- | :-- | :-- |
| SCRIPT_DIR | (unset) | Add scripts to folder set by this variable. Scripts will run as root before starting application |
| ACTIVEMQ_CONF | ${ACTIVEMQ_HOME}/conf | Override location of ActiveMQ config-folder |
| ACTIVEMQ_DATA | ${ACTIVEMQ_HOME}/data | Override location of ActiveMQ data-folder |
| ACTIVEMQ_TMP | ${ACTIVEMQ_TMP}/tmp | Override location of ActiveMQ tmp-folder |

## Example use

```bash
# Start ActiveMQ with default settings
docker run --rm -it -p 8161:8161 -p 61616:61616 kdsda/activemq:5.16.3

# ..with custom startup-scripts
docker run --rm -it \
  -v "$(pwd)"/scripts:/scripts \
  -e SCRIPT_DIR=/scripts \
  -p 8161:8161 -p 61616:61616 \
  kdsda/activemq:5.16.3

# ..with custom config-folder
docker run --rm -it \
  -v "$(pwd)"/config:/conf \
  -e ACTIVEMQ_CONF=/conf \
  -p 8161:8161 -p 61616:61616 \
  kdsda/activemq:5.16.3

# ..with custom data-folder
docker run --rm -it \
  -v "$(pwd)"/data:/data \
  -e ACTIVEMQ_DATA=/data \
  -p 8161:8161 -p 61616:61616 \
  kdsda/activemq:5.16.3

# Start bash
docker run --rm -it kdsda/activemq:5.16.3 bash
```
