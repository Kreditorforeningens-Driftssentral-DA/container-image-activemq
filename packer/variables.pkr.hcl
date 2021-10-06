# =================================================================================================
# BUILD VARIABLES
# =================================================================================================

variable activemq_version {
  description = "ActiveMQ version to download"
  type        = string
  default     = "5.16.3"
}

variable hawtio_version {
  description = "HawtIO version to download"
  type        = string
  default     = "2.14.0"
}

variable jdbc_version {
  description = "Postgres JDBC version to download"
  type        = string
  default     = "42.2.24"
}

# -------------------------------------------------------------------------------------------------

variable ansible_playbook_alpine {
  description = "Ansible playbook used for provisioning (Alpine builds)"
  type        = string
  default     = "./context/ansible/playbook.alpine.yml"
}

# -------------------------------------------------------------------------------------------------

variable registry_name {
  description = "Target registry name"
  type        = string
  default     = "registry.hub.docker.com/kdsda/activemq"
}

variable registry_tags {
  description = "Target registry tags"
  type        = list(string)
  default     = ["latest"]
}

variable registry_server {
  description = "Registry logon-server"
  type        = string
  default     = "registry.hub.docker.com"
}

variable registry_username {
  description = "Registry username"
  type        = string
  default     = "anonymous"
}

variable registry_password {
  description = "Registry password"
  type        = string
  default     = ""
}
