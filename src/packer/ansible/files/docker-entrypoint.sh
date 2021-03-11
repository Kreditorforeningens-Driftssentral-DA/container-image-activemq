#!/usr/bin/env bash
set -e

printf "\n\n*** CONTAINER INFO ***\n"
printf "  Host: $(hostname)\n"
printf "    IP: $(hostname -I)\n"
printf "    OS: $(cat /etc/issue.net)\n"
printf "*** CONTAINER INFO ***\n\n"

# -----------------------------------------------
# VALIDATE STARTUP COMMANDS
# -----------------------------------------------

case "${1}" in
  'START')
    printf "\n[ENTRYPOINT] ${1}\n\n"
    shift "${#}"
    set -- /opt/activemq/bin/activemq console
  ;;

  'DEBUG')
    printf "\n[ENTRYPOINT] ${1}\n\n"
    shift "${#}"
    set -- /usr/bin/env bash
    ;;
  *)
    printf "\n[ENTRYPOINT INFO]\n\n"
    printf "  Valid Commands:\n"
    printf "    START -> (default) Start ActiveMQ\n"
    printf "    DEBUG -> Open command-shell\n\n"
    exit 0
  ;;
esac

# -----------------------------------------------
# VALIDATE BACKEND
# -----------------------------------------------

# CHECK REQUESTED BACKEND
if [ -z $BACKEND ]; then
  echo "[INFO] Using local persistence backend (kahadb)"
  rm -f ${ACTIVEMQ_HOME}/conf/activemq.xml
  ln -s ${ACTIVEMQ_HOME}/conf/activemq.local.xml ${ACTIVEMQ_HOME}/conf/activemq.xml
elif [ "$BACKEND" == "postgres" ]; then
  echo "[INFO] Using postgres persistence backend. Loading settings from conf/db.properties"
  # Validate configuration
  if [ -z ${POSTGRES_HOST} ]; then echo "[INFO] POSTGRES_HOST is empty. Using default 'localhost'";        export POSTGRES_HOST=postgres; fi
  if [ -z ${POSTGRES_PORT} ]; then echo "[INFO] POSTGRES_PORT is empty. Using default '5432'";             export POSTGRES_PORT='5432'; fi
  if [ -z ${POSTGRES_DATABASE} ]; then echo "[INFO] POSTGRES_DATABASE is empty. Using default 'activemq'"; export POSTGRES_DATABASE=postgres; fi
  if [ -z ${POSTGRES_USERNAME} ]; then echo "[INFO] POSTGRES_USERNAME is empty. Using default 'activemq'"; export POSTGRES_USERNAME=postgres; fi
  if [ -z ${POSTGRES_PASSWORD} ]; then echo "[INFO] POSTGRES_PASSWORD is empty. Using default 'activemq'"; export POSTGRES_PASSWORD=postgres; fi
  if [ -z ${POSTGRES_INIT} ]; then echo "[INFO] POSTGRES_INITIALIZE is empty. Using default 'false'";      export POSTGRES_INIT='true'; fi
  rm -f ${ACTIVEMQ_HOME}/conf/activemq.xml
  ln -s ${ACTIVEMQ_HOME}/conf/activemq.postgres.xml ${ACTIVEMQ_HOME}/conf/activemq.xml
else
  echo "[INFO] Invalid persistence backend requested"
  exit 1
fi

# -----------------------------------------------
# VALIDATE USER
# -----------------------------------------------

if [ -z ${USERNAME} ]; then
  printf "\n[WARNING] User: root\n\n"
else
  printf "\n[INFO] User: ${USERNAME} \n\n"
  #set -- ${USERNAME} gosu "${@}"
fi

# -----------------------------------------------
# EXECUTE COMMAND
# -----------------------------------------------

exec "${@}"
