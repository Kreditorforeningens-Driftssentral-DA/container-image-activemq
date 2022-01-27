#!/usr/bin/dumb-init /bin/bash

log(){
  printf "[%s] %s\n" "$(date)" "${1}" | tee -a  /var/log/activemq-startup.log
}

log "Container startup.."

# -----------------------------------------------
# Run custom startup-scripts (as root)
# -----------------------------------------------

if [[ "${SCRIPT_DIR}" ]] && [[ -d "${SCRIPT_DIR}" ]]; then
  printf '#!/usr/bin/env bash\n' >> ${SCRIPT_DIR}/0_dummy.sh
  printf 'echo ">>> RUNNING SCRIPTS"\n' >> ${SCRIPT_DIR}/0_dummy.sh
  
  for script in $(ls "${SCRIPT_DIR}"/*.sh); do
    log "Running startup-script: ${script}"
    chmod +x ${script}
    . ${script}
  done
fi

# -----------------------------------------------
# Validate folders
# -----------------------------------------------

if [[ ! -d "${ACTIVEMQ_DATA}" ]]; then
  mkdir -p ${ACTIVEMQ_DATA}
fi

if [[ ! -d "${ACTIVEMQ_TMP}" ]]; then
  mkdir -p ${ACTIVEMQ_TMP}
fi

# -----------------------------------------------
# Set default startup-command, if none specified.
# -----------------------------------------------

if [[ -z "${1}" ]]; then
  set -- activemq console
fi

# -----------------------------------------------
# Execute as non-privileged user with GOSU
# -----------------------------------------------

if [[ -z "${RUN_AS_ROOT}" ]]; then
  log "Using non-privileged user: activemq"
  set -- gosu activemq:activemq ${@}

  log "Validating folder permissions.."
  chown -R activemq:activemq ${ACTIVEMQ_DATA}
  chown -R activemq:activemq ${ACTIVEMQ_CONF}
  chown -R activemq:activemq ${ACTIVEMQ_TMP}
fi

# -----------------------------------------------
# Execute
# -----------------------------------------------

log "Executing: $(echo ${@})"
exec ${@}
