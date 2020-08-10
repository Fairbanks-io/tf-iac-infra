##
# Output
##

output "droplet-ip" {
  value = digitalocean_droplet.vault-prod.ipv4_address
}