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
      "export JENKINS_USER=${var.jenkins_user}",
      "export JENKINS_PASS=${var.jenkins_pass}",
      # Setup DigitalOcean Metrics Agent
      "curl -sSL https://repos.insights.digitalocean.com/install.sh | sudo bash",
      # Install Docker & Docker-Compose
      "curl -fsSL https://get.docker.com -o get-docker.sh",
      "sh get-docker.sh",
      # "apt-get update", This is already ran in get-docker.sh
      "apt-get upgrade -y",
      "apt-get install docker-compose -y",
      # Setup Jenkins
      "mkdir -p /jenkinsdata",
      "curl https://raw.githubusercontent.com/Fairbanks-io/tf-iac-infra/master/resources/jenkins/docker-compose.yml --output docker-compose.yml",
      "docker-compose up -d"
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