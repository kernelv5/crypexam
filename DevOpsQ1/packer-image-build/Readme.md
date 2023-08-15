## Packer Installation

Install Packer Version : 1.6.6
Create an Security group with SSH open from the host machine.
Packer will use AWS Default public subnet for internet access.

Path : /packer-image-build/configure-docker.yml

Please adjust
"shared_credentials_file": "********",
"profile": "kar",

Packer build new image name : crypto-golden-image-{{timestamp}}


Execution : packer build pack-buil.json