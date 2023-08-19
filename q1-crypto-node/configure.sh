#!/bin/bash
set -x

chain_version=$3
tag=$2
dirnuser=$1


curl -LOJ https://github.com/crypto-org-chain/chain-main/releases/download/$tag/$chain_version
tar -zxvf $chain_version
chown -R $dirnuser:$dirnuser /$dirnuser

homedir=/$1
config=$homedir/config


echo $homedir
echo $config


if [ ! -f "$config/app.toml" ]; then
 echo "Folder Missing"
 $homedir/bin/chain-maind init ~Dmoniker~E --chain-id crypto-org-chain-mainnet-1 --home $homedir
 curl https://dl2.quicksync.io/json/addrbook.ccomchain.json > $homedir/config/addrbook.json
 curl https://raw.githubusercontent.com/crypto-org-chain/mainnet/main/crypto-org-chain-mainnet-1/genesis.json > $homedir/config/genesis.json
 sed -i.bak -E 's#~\(minimum-gas-prices~D~D:space:~E~E+=~D~D:space:~E~E+)""$#~V1"0.025basecro"#' $homedir/config/app.toml
 sed -i.bak -E 's#~\(seeds~D~D:space:~E~E+=~D~D:space:~E~E+).*$#~V1"87c3adb7d8f649c51eebe0d3335d8f9e28c362f2~Iseed-0.crypto.org:26656,e1d7ff02b78044795371beb1cd5fb803f9389256
~Iseed-1.crypto.org:26656,2c55809558a4e491e9995962e10c026eb9014655~Iseed-2.crypto.org:26656"#' $homedir/config/config.toml
 sed -i.bak -E 's#~\(create_empty_blocks_interval~D~D:space:~E~E+=~D~D:space:~E~E+).*$#~V1"5s"#' $homedir/config/config.toml
fi

 $homedir/bin/chain-maind start --home /$1
