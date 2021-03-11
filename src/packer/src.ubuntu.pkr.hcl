source docker "UBUNTU_2004" {
  image   = "registry.hub.docker.com/library/ubuntu:20.04"
  pull    = true
  commit  = true
}

source docker "UBUNTU_PREPARED" {
  image   = "local/ubuntu-base:20.04-LTS"
  pull    = false
  commit  = true
  changes = [
    "EXPOSE 8161 61616",
    #"ENV ACTIVEMQ_USER=activemq",
    "ENV ACTIVEMQ_HOME=${var.activemq_home}",
    "ENV ACTIVEMQ_BASE=$${ACTIVEMQ_HOME}",
    "ENV ACTIVEMQ_CONF=$${ACTIVEMQ_BASE}/conf",
    "ENV ACTIVEMQ_DATA=$${ACTIVEMQ_BASE}/data",
    "ENV ACTIVEMQ_TMP=$${ACTIVEMQ_BASE}/tmp",
    "WORKDIR $${ACTIVEMQ_BASE}",
    "ENTRYPOINT [\"/usr/bin/tini\", \"--\", \"/docker-entrypoint.sh\"]",
    "CMD [\"START\"]",
  ]
}
