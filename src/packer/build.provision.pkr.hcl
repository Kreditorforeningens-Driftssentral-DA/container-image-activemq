build {
  name    = "provision"
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
