FROM ubuntu:latest

RUN apt-get update && \
    apt-get install curl jq -y

RUN useradd -m -d /chain_main  chain_main

WORKDIR /chain_main
COPY ./configure.sh /chain_main/configure.sh

RUN chmod +x /chain_main/configure.sh

# https://github.com/crypto-org-chain/chain-main/releases
# Others Versions informations
CMD ["/chain_main/configure.sh" ,"chain_main","v2.1.2","chain-main_2.1.2_Linux_x86_64.tar.gz"]
