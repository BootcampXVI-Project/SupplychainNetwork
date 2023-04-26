#!/bin/bash

function one_line_pem {
    echo "`awk 'NF {sub(/\\n/, ""); printf "%s\\\\\\\n",$0;}' $1`"
}

function json_ccp {
    local PP=$(one_line_pem $4)
    local CP=$(one_line_pem $5)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${CAPORT}/$3/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        -e "s/\${MSP}/$6/" \
        organizations/ccp-template.json
}

ORG=supplier
MSP=Supplier
P0PORT=7051
CAPORT=7054
PEERPEM=organizations/peerOrganizations/supplier.supplychain.com/tlsca/tlsca.supplier.supplychain.com-cert.pem
CAPEM=organizations/peerOrganizations/supplier.supplychain.com/ca/ca.supplier.supplychain.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $MSP)" > organizations/peerOrganizations/supplier.supplychain.com/connection-supplier.json

ORG=manufacturer
MSP=Manufacturer
P0PORT=7061
CAPORT=7064
PEERPEM=organizations/peerOrganizations/manufacturer.supplychain.com/tlsca/tlsca.manufacturer.supplychain.com-cert.pem
CAPEM=organizations/peerOrganizations/manufacturer.supplychain.com/ca/ca.manufacturer.supplychain.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $MSP)" > organizations/peerOrganizations/manufacturer.supplychain.com/connection-manufacturer.json

ORG=distributor
MSP=Distributor
P0PORT=7071
CAPORT=7074
PEERPEM=organizations/peerOrganizations/distributor.supplychain.com/tlsca/tlsca.distributor.supplychain.com-cert.pem
CAPEM=organizations/peerOrganizations/distributor.supplychain.com/ca/ca.distributor.supplychain.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $MSP)" > organizations/peerOrganizations/distributor.supplychain.com/connection-distributor.json

ORG=retailer
MSP=Retailer
P0PORT=7081
CAPORT=7084
PEERPEM=organizations/peerOrganizations/retailer.supplychain.com/tlsca/tlsca.retailer.supplychain.com-cert.pem
CAPEM=organizations/peerOrganizations/retailer.supplychain.com/ca/ca.retailer.supplychain.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $MSP)" > organizations/peerOrganizations/retailer.supplychain.com/connection-retailer.json

ORG=consumer
MSP=Consumer
P0PORT=7091
CAPORT=7094
PEERPEM=organizations/peerOrganizations/consumer.supplychain.com/tlsca/tlsca.consumer.supplychain.com-cert.pem
CAPEM=organizations/peerOrganizations/consumer.supplychain.com/ca/ca.consumer.supplychain.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $MSP)" > organizations/peerOrganizations/consumer.supplychain.com/connection-consumer.json


cp -r "${PWD}/organizations/peerOrganizations/supplier.supplychain.com/connection-supplier.json" "${PWD}/../supply-chain-application/web-app/servers/configs"
cp -r "${PWD}/organizations/peerOrganizations/manufacturer.supplychain.com/connection-manufacturer.json" "${PWD}/../supply-chain-application/web-app/servers/configs"
cp -r "${PWD}/organizations/peerOrganizations/distributor.supplychain.com/connection-distributor.json" "${PWD}/../supply-chain-application/web-app/servers/configs"
cp -r "${PWD}/organizations/peerOrganizations/retailer.supplychain.com/connection-retailer.json" "${PWD}/../supply-chain-application/web-app/servers/configs"
cp -r "${PWD}/organizations/peerOrganizations/consumer.supplychain.com/connection-consumer.json" "${PWD}/../supply-chain-application/web-app/servers/configs"