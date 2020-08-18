# DigitalOcean k8s with Terraform

![GitHub top language](https://img.shields.io/github/languages/top/jonfairbanks/terraform.svg)
![GitHub last commit](https://img.shields.io/github/last-commit/jonfairbanks/terraform.svg)
![Terraform](https://github.com/jonfairbanks/terraform/workflows/Terraform/badge.svg?branch=master)
![License](https://img.shields.io/github/license/jonfairbanks/terraform.svg?style=flat)
![PRs Welcome](https://img.shields.io/badge/PRs-welcome-green.svg)

## TODO
- [ ] Add output for vault fqdn to be used in other modules
- [ ] Create script to generate keys and publish automatically digital ocean, then create workspace and set variables accordingly
- [ ] Finish this Readme
- [ ] Document how others can submit PR
- [ ] Add Jenkins 'first steps' to docs.

## Getting Started
  1. Make terraform workspace named 'tf-iac-infra'
  2. generate ssh key and capture pub key, private key, and thumbprint
  3. Add SSH key to digital ocean
  4. Add variables DO_TOKEN, PVT_KEY, PUB_KEY, SSH_THUMBPRINT, CLOUDFLARE_EMAIL, CLOUDFLARE_API_KEY, CLOUDFLARE_ZONE_ID to tf workspace
  5. make a commit to develop to trigger the 'terraform plan'
  6. merge to master to trigger the 'terraform apply'
  7. connect to vault and exec commands to unseal:
    - STEPS:
