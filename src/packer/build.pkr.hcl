build {
  name    = "prepare"
  sources = ["source.docker.UBUNTU_2004"]

  # PREPARE CONTAINER IMAGE
  provisioner "shell" {
    environment_vars =[
      "SKIP_UPGRADE=1"
    ]
    inline = [
      "echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections",
      "apt-get update","if [ -z $SKIP_UPGRADE ]; then apt-get -qqy upgrade;fi",
      "apt-get -qqy install apt-utils",
      "apt-get -qqy install tini gosu unzip",
      "apt-get -qqy install python3-simplejson python3-apt",
      "apt-get -qqy install openjdk-11-jre-headless",
      "apt-get autoclean",
    ]
  }

  post-processors {
    # TAG CONTAINER IMAGE
    post-processor "docker-tag" {
      repository = "local/ubuntu-base"
      tags       = ["20.04-LTS"]
    }
  }
}

build {
  name    = "v0.1.0"
  sources = ["source.docker.UBUNTU_PREPARED"]

  # PROVISION CONTAINER IMAGE
  provisioner "ansible" {
    user = "root"
    playbook_file = "ansible/provision.yml"
    extra_arguments = [
      "--extra-vars",
      join(" ", [
        "ACTIVEMQ_VERSION=${var.activemq_version}",
        "ACTIVEMQ_HOME=${var.activemq_home}",
        "HAWTIO_VERSION=${var.hawtio_version}",
        "JDBC_POSTGRES_VERSION=${var.jdbc_postgres_version}",
      ])
    ]
  }

  post-processors {
    # TAG CONTAINER IMAGE
    post-processor "docker-tag" {
      repository = var.docker_image_name
      tags       = ["latest", var.docker_image_tag]
      #tags       = var.docker_image_tags
    }

    # UPLOAD CONTAINER IMAGE
    post-processor "docker-push" {
      name           = "push"
      login          = true
      login_server   = var.docker_login_server
      login_username = var.docker_login_username
      login_password = var.docker_login_password
    }
  }
}
