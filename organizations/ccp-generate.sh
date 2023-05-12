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
        ccp-template.json
}

ORG=supplier
MSP=Supplier
P0PORT=7051
CAPORT=7054
PEERPEM=peerOrganizations/supplier.supplychain.com/tlsca/tlsca.supplier.supplychain.com-cert.pem
CAPEM=peerOrganizations/supplier.supplychain.com/ca/ca.supplier.supplychain.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $MSP)" > peerOrganizations/supplier.supplychain.com/connection-supplier.json

ORG=manufacturer
MSP=Manufacturer
P0PORT=7061
CAPORT=7064
PEERPEM=peerOrganizations/manufacturer.supplychain.com/tlsca/tlsca.manufacturer.supplychain.com-cert.pem
CAPEM=peerOrganizations/manufacturer.supplychain.com/ca/ca.manufacturer.supplychain.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $MSP)" > peerOrganizations/manufacturer.supplychain.com/connection-manufacturer.json

ORG=distributor
MSP=Distributor
P0PORT=7071
CAPORT=7074
PEERPEM=peerOrganizations/distributor.supplychain.com/tlsca/tlsca.distributor.supplychain.com-cert.pem
CAPEM=peerOrganizations/distributor.supplychain.com/ca/ca.distributor.supplychain.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $MSP)" > peerOrganizations/distributor.supplychain.com/connection-distributor.json

ORG=retailer
MSP=Retailer
P0PORT=7081
CAPORT=7084
PEERPEM=peerOrganizations/retailer.supplychain.com/tlsca/tlsca.retailer.supplychain.com-cert.pem
CAPEM=peerOrganizations/retailer.supplychain.com/ca/ca.retailer.supplychain.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $MSP)" > peerOrganizations/retailer.supplychain.com/connection-retailer.json

ORG=consumer
MSP=Consumer
P0PORT=7091
CAPORT=7094
PEERPEM=peerOrganizations/consumer.supplychain.com/tlsca/tlsca.consumer.supplychain.com-cert.pem
CAPEM=peerOrganizations/consumer.supplychain.com/ca/ca.consumer.supplychain.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $MSP)" > peerOrganizations/consumer.supplychain.com/connection-consumer.json


cp -r "${PWD}/peerOrganizations/supplier.supplychain.com/connection-supplier.json" "${PWD}/../../supply_chain_application/configs"
cp -r "${PWD}/peerOrganizations/manufacturer.supplychain.com/connection-manufacturer.json" "${PWD}/../../supply_chain_application/configs"
cp -r "${PWD}/peerOrganizations/distributor.supplychain.com/connection-distributor.json" "${PWD}/../../supply_chain_application/configs"
cp -r "${PWD}/peerOrganizations/retailer.supplychain.com/connection-retailer.json" "${PWD}/../../supply_chain_application/configs"
cp -r "${PWD}/peerOrganizations/consumer.supplychain.com/connection-consumer.json" "${PWD}/../../supply_chain_application/configs"