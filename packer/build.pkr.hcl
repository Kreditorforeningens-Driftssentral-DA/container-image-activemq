# https://github.com/disaster37/activemq/blob/master/Dockerfile
# https://www.packer.io/docs/builders/docker
# https://github.com/vterdunov/ansible-activemq
# https://hawt.io/docs/get-started/
# https://github.com/hawtio/hawtio
# =================================================================================================
# BUILD PARAMETERS
# =================================================================================================

locals {
  activemq_version        = var.activemq_version
  hawtio_version          = var.hawtio_version
  jdbc_version            = var.jdbc_version
  ansible_playbook_alpine = var.ansible_playbook_alpine
  registry_name           = var.registry_name
  registry_tags           = var.registry_tags
  registry_server         = var.registry_server
  registry_username       = var.registry_username
  registry_password       = var.registry_password
}

# =================================================================================================
# SOURCE IMAGE(S)
# =================================================================================================

source docker "ALPINE" {
  image       = "registry.hub.docker.com/library/alpine:3"
  export_path = "./activemq-alpine.tar"
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

    playbook_file = local.ansible_playbook_alpine
    extra_arguments = [
      "--extra-vars",
      join(" ", [
        "\"",
        "PACKER_ACTIVEMQ_VERSION=${local.activemq_version}",
        "PACKER_HAWTIO_VERSION=${local.hawtio_version}",
        "PACKER_JDBC_VERSION=${local.jdbc_version}",
        "PACKER_JAVA_VERSION=openjdk11-jre-headless",
        "\"",
      ])
    ]
  }

  # -------------------------------------------------------------------------------------------------
  # PROVISION | Upload startup-scripts
  # -------------------------------------------------------------------------------------------------

  provisioner "file" {
    only = [
      "docker.ALPINE",
    ]

    direction   = "upload"
    source      = "context/files"
    destination = "/opt"
  }

  provisioner "shell" {
    only = [
      "docker.ALPINE",
    ]

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

      repository = "${local.registry_name}"
      tag        = "alpine"

      # Removes exported tar by default
      keep_input_artifact = false

      changes = [
        "ENV ACTIVEMQ_HOME /opt/activemq",
        "ENV ACTIVEMQ_CONF /opt/activemq/conf",
        "ENV ACTIVEMQ_DATA /data/activemq",
        "ENV ACTIVEMQ_TMP  /data/tmp",
        "EXPOSE 1883 5672 8161 61613 61614 61616",
        "USER activemq",
        "WORKDIR /opt/activemq",
        "CMD /opt/files/docker-entrypoint.sh",
      ]
    }

    post-processor "docker-tag" {
      repository = local.registry_name
      tags       = local.registry_tags
    }

    # UPLOAD CONTAINER IMAGE
    post-processor "docker-push" {
      name = "push"

      login          = true
      login_server   = local.registry_server
      login_username = local.registry_username
      login_password = local.registry_password
    }
  }
}