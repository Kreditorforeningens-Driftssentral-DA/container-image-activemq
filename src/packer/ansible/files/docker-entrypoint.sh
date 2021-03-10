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
  'start')
    printf "\n[ENTRYPOINT] ${1}\n\n"
    shift "${#}"
    set -- /opt/activemq/bin/activemq console
    ;;
  'debug')
    printf "\n[ENTRYPOINT] ${1}\n\n"
    exec /usr/bin/env bash
    exit 0
    ;;
  *)
    printf "\n[ENTRYPOINT INFO]\n\n"
    printf "  Valid Commands:\n"
    printf "    start -> (default) Start ActiveMQ\n"
    printf "    debug -> Open shell\n\n"
    exit 0
  ;;
esac

# -----------------------------------------------
# VALIDATE VARIABLES
#-----------------------------------------------

# Required; exit if missing
#if [ -z ${REQUIRED_VAR} ]; then echo "[ERROR] Required variable REQUIRED_VAR is not set."; exit 1; fi

# Optional; warn if missing
#if [ -z ${OPTIONAL_ARG} ]; then echo "[INFO] Variable OPTIONAL_ARG is empty."; fi

# -----------------------------------------------
# EXECUTE COMMAND
# -----------------------------------------------

if [ -z ${USERNAME} ]; then
  printf "\n[WARNING] User: root\n\n"
else
  printf "\n[INFO] User: ${USERNAME} \n\n"
  #set -- ${USERNAME} gosu "${@}"
fi

exec "${@}"
