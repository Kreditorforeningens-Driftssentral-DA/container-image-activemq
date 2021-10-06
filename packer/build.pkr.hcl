# https://github.com/disaster37/activemq/blob/master/Dockerfile
# https://www.packer.io/docs/builders/docker
# https://github.com/vterdunov/ansible-activemq
# =================================================================================================
# BUILD PARAMETERS
# =================================================================================================

locals {
  ansible_playbook = "./context/ansible/playbook.alpine.yml"
}

# =================================================================================================
# SOURCE IMAGE(S)
# =================================================================================================

source docker "ALPINE" {
  image = "registry.hub.docker.com/library/alpine:3"
  export_path = "./activemq.tar"
}

# =================================================================================================
# BUILD & PROVISION
# =================================================================================================

build {
  sources = [
    "source.docker.ALPINE",
  ]

# -------------------------------------------------------------------------------------------------
# PROVISION | OS-Specific customization
# -------------------------------------------------------------------------------------------------
  
  # APK-distributions (Alpine)
  provisioner "shell" {
    only = [
      "docker.ALPINE",
    ]
    
    # Install Ansible (Core)
    inline = [
      <<-PREPROVISION
      apk add --no-cache tar unzip curl python3 py3-pip py3-cryptography py3-yaml py3-paramiko py3-lxml
      python3 -m pip install -U pip wheel
      python3 -m pip install -U ansible-core
      PREPROVISION
    ]
  }

  # Add Ansible community.general: ~12MB
  provisioner "shell" {
    inline = [
      "ansible-galaxy collection install community.general",
    ]
  }

# -------------------------------------------------------------------------------------------------
# PROVISION | Ansible playbook(s)
# -------------------------------------------------------------------------------------------------

  # Install ActiveMQ
  provisioner "ansible-local" {
    only = [
      "docker.ALPINE",
    ]

    playbook_file = local.ansible_playbook
  }

# -------------------------------------------------------------------------------------------------
# PROVISION | Upload startup-scripts
# -------------------------------------------------------------------------------------------------

  provisioner "file" {
    direction   = "upload"
    source      = "context/files"
    destination = "/opt"
  }

  provisioner "shell" {
    inline = [
      "chown -R activemq:activemq /opt/files",
      "chmod +x /opt/files/docker-entrypoint.sh",
    ]
  }

# -------------------------------------------------------------------------------------------------
# FINALIZE
# -------------------------------------------------------------------------------------------------

  post-processors {
    post-processor "docker-import" {
      only = [
        "docker.ALPINE",
      ]
      
      repository = "local/activemq"
      tag = "alpine"

      changes = [
        "ENV ACTIVEMQ_HOME /opt/activemq",
        "ENV ACTIVEMQ_CONF /opt/activemq/conf",
        "ENV ACTIVEMQ_DATA /data/activemq",
        "ENV ACTIVEMQ_TMP  /data/tmp",
        "EXPOSE 1883 5672 8161 61613 61614 61616",
        "WORKDIR /opt/activemq",
        "CMD /opt/files/docker-entrypoint.sh",
      ]
    }
  }
}