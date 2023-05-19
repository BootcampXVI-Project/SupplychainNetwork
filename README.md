# Install fabric 2.5

```bash
curl -sSL https://bit.ly/2ysbOFE | bash -s
```

# Change directory to folder fabric-samples

```bash
cd fabric-samples
```

# Clone SupplychainNetwork into fabric-samples

```bash
git clone https://github.com/BootcampXVI-Project/SupplychainNetwork.git
```

# Running the Supplychain Network

## Change directory to folder Supplychain Network

```bash
cd SupplychainNetwork
```

## Run network

```bash
./network.sh up createChannel -ca
```

# Using the Peer commands

The `envVar.sh` script can be used to set up the environment variables for the organizations, this will help to be able to use the `peer` commands directly.

First, ensure that the peer binaries are on your path, and the Fabric Config path is set assuming that you're in the `SupplychainNetwork` directory.

```bash
export PATH=${PWD}/../bin:$PATH
export FABRIC_CFG_PATH=$PWD/../config/
```

You can then set up the environment variables for each organization. The `./scripts/envVar.sh` command is designed to be run as follows.

```bash
source ./scripts/envVar.sh && setGlobals $ORG
```
