#!/usr/bin/dumb-init /bin/bash

log(){
  printf "[%s] %s\n" "$(date)" "${1}" | tee -a  /var/log/activemq-startup.log
}
log "Container startup"

# Run custom startup-scripts (as root)
if [[ "${SCRIPT_DIR}" ]] && [[ -d "${SCRIPT_DIR}" ]]; then
  printf '#!/usr/bin/env bash\n' >> ${SCRIPT_DIR}/0_dummy.sh
  printf 'echo "Custom scripts running as $(whoami)"\n' >> ${SCRIPT_DIR}/0_dummy.sh
  
  for script in $(ls "${SCRIPT_DIR}"/*.sh); do
    log "Script: ${script}"
    chmod +x ${script}
    . ${script}
  done
fi

# Validate folders
if [[ ! -d "${ACTIVEMQ_DATA}" ]]; then
  mkdir -p ${ACTIVEMQ_DATA}
fi

if [[ ! -d "${ACTIVEMQ_CONF}" ]]; then
  mkdir -p ${ACTIVEMQ_CONF}
fi

if [[ ! -d "${ACTIVEMQ_TMP}" ]]; then
  mkdir -p ${ACTIVEMQ_TMP}
fi

# Use default startup-command, if no arguments
if [[ -z "${1}" ]]; then
  set -- activemq console
fi

# Execute as activemq, using gosu (unless root)
if [[ "${ACTIVEMQ_USER}" != "root" ]]; then
  chown -R activemq:activemq ${ACTIVEMQ_HOME}
  set -- gosu activemq:activemq ${@}
fi

# Execute application
log "Command (User: ${ACTIVEMQ_USER}): $(echo ${@})"
exec ${@}
