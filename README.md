# Building a supply chain management system for OCOP goods and agricultural products based on Hyperledger Fabric platform

# 1. Install Hyperledger Fabric 2.5.0

## Install Hyperledger Fabric

```bash
curl -sSL https://bit.ly/2ysbOFE | bash -s
```

## Grant permission for folder fabric-samples

```bash
chown -R <ubuntu-user-name> ./fabric-samples
```

## Change directory to folder fabric-samples

```bash
cd fabric-samples
```

# 2. Clone needed source to this project

```bash
git clone https://github.com/BootcampXVI-Project/SupplychainNetwork.git
```

```bash
git clone https://github.com/BootcampXVI-Project/supplychain_chaincode.git
```

```bash
git clone https://github.com/BootcampXVI-Project/supply_chain_application.git
```

```bash
git clone https://github.com/BootcampXVI-Project/explorer.git
```

```bash
git clone https://github.com/BootcampXVI-Project/supply_chain_client.git
```

# 3. Running the Supplychain Network

## Change directory to folder Supplychain Network

```bash
cd SupplychainNetwork
```

## Run network

```bash
./network.sh up createChannel -ca -s couchdb
```

## Deploy chaincode (smart contract)

```bash
./network.sh deployCC -ccn basic -ccp ../supplychain_chaincode/go/ -ccl go
```

## Export PATH and FABRIC_CFG_PATH

```bash
export PATH=${PWD}/../bin:$PATH
export FABRIC_CFG_PATH=$PWD/../config/
```

### Predeclare for authorize

```bash
ORDERER_ADDRESS=localhost:7050
ORDERER_TLS_CERT="${PWD}/organizations/ordererOrganizations/supplychain.com/orderers/orderer.supplychain.com/msp/tlscacerts/tlsca.supplychain.com-cert.pem"

SUPPLIER_PEER_ADDRESS=localhost:7051
SUPPLIER_PEER_TLS_CERT="${PWD}/organizations/peerOrganizations/supplier.supplychain.com/peers/peer0.supplier.supplychain.com/tls/ca.crt"

MANUFACTURER_PEER_ADDRESS=localhost:7061
MANUFACTURER_PEER_TLS_CERT="${PWD}/organizations/peerOrganizations/manufacturer.supplychain.com/peers/peer0.manufacturer.supplychain.com/tls/ca.crt"

DISTRIBUTOR_PEER_ADDRESS=localhost:7071
DISTRIBUTOR_PEER_TLS_CERT="${PWD}/organizations/peerOrganizations/distributor.supplychain.com/peers/peer0.distributor.supplychain.com/tls/ca.crt"

RETAILER_PEER_ADDRESS=localhost:7081
RETAILER_PEER_TLS_CERT="${PWD}/organizations/peerOrganizations/retailer.supplychain.com/peers/peer0.retailer.supplychain.com/tls/ca.crt"

CONSUMER_PEER_ADDRESS=localhost:7091
CONSUMER_PEER_TLS_CERT="${PWD}/organizations/peerOrganizations/consumer.supplychain.com/peers/peer0.consumer.supplychain.com/tls/ca.crt"
```

### Define channel and chaincode name

```bash
CHANNEL_NAME=supplychain-channel
CHAINCODE_NAME=basic
```

### Set up the environment variables for each organization

```bash
source ./scripts/envVar.sh && setGlobals supplier
```

### Init ledger

```bash
peer chaincode invoke \
  -o $ORDERER_ADDRESS \
  --ordererTLSHostnameOverride orderer.supplychain.com \
  --tls \
  --cafile $ORDERER_TLS_CERT \
  -C $CHANNEL_NAME \
  -n $CHAINCODE_NAME \
  --peerAddresses $SUPPLIER_PEER_ADDRESS \
  --tlsRootCertFiles $SUPPLIER_PEER_TLS_CERT \
  --peerAddresses $MANUFACTURER_PEER_ADDRESS \
  --tlsRootCertFiles $MANUFACTURER_PEER_TLS_CERT \
  --peerAddresses $DISTRIBUTOR_PEER_ADDRESS \
  --tlsRootCertFiles $DISTRIBUTOR_PEER_TLS_CERT \
  --peerAddresses $RETAILER_PEER_ADDRESS \
  --tlsRootCertFiles $RETAILER_PEER_TLS_CERT \
  --peerAddresses $CONSUMER_PEER_ADDRESS \
  --tlsRootCertFiles $CONSUMER_PEER_TLS_CERT \
  -c '{"function":"InitLedger","Args":[]}'
```

### Generate organization config files

```bash
cd organizations
```

```bash
./ccp-generate.sh
```

# 4. Running the explorer

## Change directory to folder explorer

```bash
cd ../../explorer
```

## Copy entire crypto artifact directory (organizations/)

```bash
cp -r ../SupplychainNetwork/organizations/ .
```

## start up explore and explorer-db services

```bash
docker-compose up -d
```

# 5. Running the supply_chain_application

## Change directory to folder supply_chain_application

```bash
cd ../supply_chain_application
```

## Install npm packages

```bash
npm install
```

## Start application

```bash
npm start
```

# 6. Running the Web Application

## Change directory to folder supply_chain_client

```bash
cd ../supply_chain_client
```

## Install npm packages

```bash
npm install
```

## Build Angular project

```bash
ng build
```

## Start application

```bash
ng serve
```
