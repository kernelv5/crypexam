FROM ubuntu:latest

RUN apt-get update && \
    apt-get install curl jq -y

RUN useradd -m -d /chain_main  chain_main

WORKDIR /chain_main
COPY ./configure.sh /chain_main/configure.sh

RUN chmod +x /chain_main/configure.sh

CMD ["/chain_main/configure.sh" ,"chain_main","v2.1.2","chain-main_2.1.2_Linux_x86_64.tar.gz"]
