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
PEERPEM=organizations/peerOrganizations/supplier.scm.com/tlsca/tlsca.supplier.scm.com-cert.pem
CAPEM=organizations/peerOrganizations/supplier.scm.com/ca/ca.supplier.scm.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $MSP)" > organizations/peerOrganizations/supplier.scm.com/connection-supplier.json

ORG=manufacturer
MSP=Manufacturer
P0PORT=7061
CAPORT=7064
PEERPEM=organizations/peerOrganizations/manufacturer.scm.com/tlsca/tlsca.manufacturer.scm.com-cert.pem
CAPEM=organizations/peerOrganizations/manufacturer.scm.com/ca/ca.manufacturer.scm.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $MSP)" > organizations/peerOrganizations/manufacturer.scm.com/connection-manufacturer.json

ORG=distributor
MSP=Distributor
P0PORT=7071
CAPORT=7074
PEERPEM=organizations/peerOrganizations/distributor.scm.com/tlsca/tlsca.distributor.scm.com-cert.pem
CAPEM=organizations/peerOrganizations/distributor.scm.com/ca/ca.distributor.scm.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $MSP)" > organizations/peerOrganizations/distributor.scm.com/connection-distributor.json

ORG=retailer
MSP=Retailer
P0PORT=7081
CAPORT=7084
PEERPEM=organizations/peerOrganizations/retailer.scm.com/tlsca/tlsca.retailer.scm.com-cert.pem
CAPEM=organizations/peerOrganizations/retailer.scm.com/ca/ca.retailer.scm.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $MSP)" > organizations/peerOrganizations/retailer.scm.com/connection-retailer.json


cp -r "${PWD}/organizations/peerOrganizations/supplier.scm.com/connection-supplier.json" "${PWD}/../supply-chain-application/web-app/servers/configs"
cp -r "${PWD}/organizations/peerOrganizations/manufacturer.scm.com/connection-manufacturer.json" "${PWD}/../supply-chain-application/web-app/servers/configs"
cp -r "${PWD}/organizations/peerOrganizations/distributor.scm.com/connection-distributor.json" "${PWD}/../supply-chain-application/web-app/servers/configs"
cp -r "${PWD}/organizations/peerOrganizations/retailer.scm.com/connection-retailer.json" "${PWD}/../supply-chain-application/web-app/servers/configs"