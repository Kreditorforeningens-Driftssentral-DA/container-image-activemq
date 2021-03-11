build {
  name    = "prepare"
  sources = ["source.docker.UBUNTU_2004"]

  # PREPARE CONTAINER IMAGE
  provisioner "shell" {
    environment_vars =[
      "SKIP_UPGRADE=1"
    ]
    inline = [
      "set -e",
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
