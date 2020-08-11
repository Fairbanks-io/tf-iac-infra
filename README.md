# DigitalOcean k8s with Terraform

![GitHub top language](https://img.shields.io/github/languages/top/jonfairbanks/terraform.svg)
![GitHub last commit](https://img.shields.io/github/last-commit/jonfairbanks/terraform.svg)
![Terraform](https://github.com/jonfairbanks/terraform/workflows/Terraform/badge.svg?branch=master)
![License](https://img.shields.io/github/license/jonfairbanks/terraform.svg?style=flat)

## TODO
- [ ] Add cloudflare provider to automatically create vault.domain.tld DNS record
- [ ] Add output for Vault domain to be used in other modules
- [ ] Create script to generate keys and publish automatically to DigitalOcean and set workspace variables accordingly
- [ ] Finish this Readme
- [ ] Add Jenkins

## Getting Started
  1. Make terraform workspace named 'tf-iac-infra'
  2. Generate SSH key and capture pub key, private key, and thumbprint
  3. Add SSH key(s) to DigitalOcean
  4. Add variables DO_TOKEN, PVT_KEY, PUB_KEY, SSH_THUMBPRINT to tf workspace
  5. Make a commit to develop to trigger the 'terraform plan'
  6. Merge to master to trigger the 'terraform apply'
  7. Connect to the Vault and unseal it:
    - STEPS:
