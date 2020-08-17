###
# Vault Box
###

resource "digitalocean_droplet" "vault-prod" {
  image              = "ubuntu-18-04-x64"
  name               = "vault-prod"
  region             = "sfo2"
  size               = "s-1vcpu-1gb"
  private_networking = true
  ssh_keys = [
    var.ssh_fingerprint
  ]

  connection {
    host        = self.ipv4_address
    user        = "root"
    type        = "ssh"
    private_key = var.pvt_key
    timeout     = "2m"
  }

  provisioner "remote-exec" {
    inline = [
      "export PATH=$PATH:/usr/bin",
      # Setup DigitalOcean Metrics Agent
      "curl -sSL https://repos.insights.digitalocean.com/install.sh | sudo bash",
      # Install Docker & Docker-Compose
      "curl -fsSL https://get.docker.com -o get-docker.sh",
      "sh get-docker.sh",
      # "apt-get update", This is already ran in get-docker.sh
      "apt-get upgrade -y",
      "apt-get install docker-compose -y",
      # Setup HashiVault
      "mkdir -p volumes/config",
      "mkdir -p volumes/file",
      "mkdir -p volumes/logs",
      "curl https://raw.githubusercontent.com/Fairbanks-io/tf-iac-infra/master/resources/vault/docker-compose.yml --output docker-compose.yml",
      "curl https://raw.githubusercontent.com/Fairbanks-io/tf-iac-infra/master/resources/vault/vault.json --output volumes/config/vault.json",
      "docker-compose up -d"
    ]
  }
}

###
# Jenkins Box
###

resource "cloudflare_record" "vault" {
  zone_id = var.cloudflare_zone_id
  name    = "vault"
  proxied = true
  value   = digitalocean_droplet.vault-prod.ipv4_address
  type    = "A"
  ttl     = 1
}

resource "digitalocean_droplet" "jenkins-prod" {
  image              = "ubuntu-18-04-x64"
  name               = "jenkins-prod"
  region             = "sfo2"
  size               = "s-1vcpu-1gb"
  private_networking = true
  ssh_keys = [
    var.ssh_fingerprint
  ]

  connection {
    host        = self.ipv4_address
    user        = "root"
    type        = "ssh"
    private_key = var.pvt_key
    timeout     = "2m"
  }

  provisioner "remote-exec" {
    inline = [
      "export PATH=$PATH:/usr/bin",
      # Setup DigitalOcean Metrics Agent
      "curl -sSL https://repos.insights.digitalocean.com/install.sh | sudo bash",
      # Install Docker & Docker-Compose
      "curl -fsSL https://get.docker.com -o get-docker.sh",
      "sh get-docker.sh",
      # "apt-get update", This is already ran in get-docker.sh
      "apt-get upgrade -y",
      "apt-get install docker-compose -y",
      # Setup Jenkins Blue Ocean
      "docker network create jenkins",
      "docker volume create jenkins-docker-certs",
      "docker volume create jenkins-data",
      "docker container run --name jenkins-docker --detach --privileged --network jenkins --network-alias docker --env DOCKER_TLS_CERTDIR=/certs --volume jenkins-docker-certs:/certs/client --volume jenkins-data:/var/jenkins_home --publish 2376:2376 --restart always docker:dind",
      "docker container run --name jenkins-blueocean --detach --network jenkins --env DOCKER_HOST=tcp://docker:2376 --env DOCKER_CERT_PATH=/certs/client --env DOCKER_TLS_VERIFY=1 --volume jenkins-data:/var/jenkins_home --volume jenkins-docker-certs:/certs/client:ro --env JENKINS_USER=${var.jenkins_user} --env JENKINS_PASS=${var.jenkins_pass} --env JAVA_OPTS=-Djenkins.install.runSetupWizard=false --publish 80:8080 --publish 50000:50000 --restart always jenkinsci/blueocean",
    ]
  }
}

resource "cloudflare_record" "jenkins" {
  zone_id = var.cloudflare_zone_id
  name    = "jenkins"
  proxied = true
  value   = digitalocean_droplet.jenkins-prod.ipv4_address
  type    = "A"
  ttl     = 1
}