# DigitalOcean k8s with Terraform (Part 1)

![GitHub top language](https://img.shields.io/github/languages/top/jonfairbanks/terraform.svg)
![GitHub last commit](https://img.shields.io/github/last-commit/jonfairbanks/terraform.svg)
![Terraform](https://github.com/jonfairbanks/terraform/workflows/Terraform/badge.svg?branch=master)
![License](https://img.shields.io/github/license/jonfairbanks/terraform.svg?style=flat)

## TODO
- [ ] Finish this Readme
- [ ] Add Jenkins
- [ ] Check Terraform Version in TF Remote workspace
- [ ] Add docs for ssh key generation 

## Getting Started
    1. Make terraform workspace named 'tf-iac-infra'
    2. generate ssh key and capture pub key, private key, and thumbprint
    3. Add variables DO_TOKEN, PVT_KEY, PUB_KEY, SSH_THUMBPRINT to tf workspace
    4. make a commit to develop to trigger the 'terraform plan'
    5. merge to master to trigger the 'terraform apply'
    6. connect to vault and exec commands to unseal:
        - STEPS:
