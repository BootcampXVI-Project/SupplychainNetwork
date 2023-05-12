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
const msps: string[] = []
const mspSupplier = "SupplierMSP"
const mspManufacturer = "ManufacturerMSP"
const mspDistributor = "DistributorMSP"
const mspRetailer = "RetailerMSP"
const mspConsumer = "ConsumerMSP"
msps.push(mspSupplier)
msps.push(mspManufacturer)
msps.push(mspDistributor)
msps.push(mspRetailer)
msps.push(mspConsumer)

const walletPath = path.join(__dirname, 'wallet');
console.log("DEBUG", walletPath)
//const org1UserId = 'typescriptAppUser';
const userIds: string[] = []
const supplierUserId = "SupplierUserId"
const manufacturerUserId = "ManufacturerUserId"
const distributorUserId = "DistributorUserId"
const retailerUserId = "RetailerUserId"
const consumerUserId = "ConsumerUserId"
userIds.push(supplierUserId);
userIds.push(manufacturerUserId);
userIds.push(distributorUserId);
userIds.push(retailerUserId);
userIds.push(consumerUserId);

const pathdirs: string[] = []
pathdirs.push('connection-supplier.json')
pathdirs.push('connection-manufacturer.json')
pathdirs.push('connection-distributor.json')
pathdirs.push('connection-retailer.json')
pathdirs.push('connection-consumer.json')

const cas: string[] = []
cas.push('ca.supplier.supplychain.com')
cas.push('ca.manufacturer.supplychain.com')
cas.push('ca.distributor.supplychain.com')
cas.push('ca.retailer.supplychain.com')
cas.push('ca.consumer.supplychain.com')

const orgs: string[] = []
orgs.push('supplier')
orgs.push('manufacturer')
orgs.push('distributor')
orgs.push('retailer')
orgs.push('consumer')

try {
        for (let i = 0; i<5; i++){
            const ccp = buildCCPOrg(pathdirs[i]);

            const caClient = buildCAClient(ccp, cas[i]);

            const wallet = await buildWallet(walletPath);

            await enrollAdmin(caClient, wallet, msps[i]);

            await registerAndEnrollUser(caClient, wallet, msps[i], userIds[i], orgs[i]+'.department');

            const gateway = new Gateway();

            const gatewayOpts: GatewayOptions = {
                wallet,
                identity: userIds[i],
                discovery: { enabled: true, asLocalhost: true }, // using asLocalhost as this gateway is using a fabric network deployed locally
            };

            try{
                await gateway.connect(ccp, gatewayOpts);

                const network = await gateway.getNetwork(channelName);

                const contract = network.getContract(chaincodeName);

                
            } finally {
                gateway.disconnect();
            }
        }
    } catch (error) {
            console.error(`******** FAILED to run the application: ${error}`);
            process.exit(1);
    }
