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
      "apt-get update",
      "apt-get upgrade -y",
      # Install Docker
      "curl -fsSL https://get.docker.com -o get-docker.sh",
      "sh get-docker.sh",
      # Install Docker-Compose
      "apt-get install docker-compose -y",
      # Setup HashiVault
      "touch docker-compose.yml",
      "mkdir -p volumes/config",
      "mkdir -p volumes/file",
      "mkdir -p volumes/logs",
      "curl https://raw.githubusercontent.com/Fairbanks-io/tf-iac-infra/master/resources/docker-compose.yml --output docker-compose.yml",
      "curl https://raw.githubusercontent.com/Fairbanks-io/tf-iac-infra/master/resources/vault.json --output volumes/config/vault.json",
      "docker-compose up -d"
    ]
  }
}

resource "cloudflare_record" "vault" {
  zone_id = var.cloudflare_zone_id
  name    = "vault"
  proxied = true
  value   = digitalocean_droplet.vault-prod.ipv4_address
  type    = "A"
  ttl     = 1
}