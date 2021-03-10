# Docker image settings
variable docker_image_name {
  type    = string
  default = "local/activemq"
}

variable docker_image_tags {
  type    = list(string)
  default = ["dev"]
}

variable docker_login_username {
  type    = string
  default = "username"
}

variable docker_login_server {
  type    = string
  default = "https://127.0.0.1:5000"
}

variable docker_login_password {
  type    = string
  default = "secret"
}

# ANSIBLE PROVISIONING
variable activemq_version {
  type    = string
  default = "5.16.1"
}

variable activemq_home {
  type    = string
  default = "/opt/activemq"
}

variable java_version {
  type    = string
  default = "openjdk-11-jre-headless"
}

variable hawtio_version {
  type    = string
  default = "2.13.0"
}

variable jdbc_postgres_version {
  type    = string
  default = "42.2.18"
}

variable postgres_database_host {
  type    = string
  default = "127.0.0.1:5432"
}

variable postgres_database_name {
  type    = string
  default = "activemq"
}

variable postgres_database_user {
  type    = string
  default = "activemq"
}

variable postgres_database_secret {
  type    = string
  default = "activemq"
}
