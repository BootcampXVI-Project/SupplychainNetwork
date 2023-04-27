#!/bin/bash
#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#

# This is a collection of bash functions used by different scripts

# imports
. scripts/utils.sh

export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/organizations/ordererOrganizations/supplychain.com/tlsca/tlsca.supplychain.com-cert.pem
export PEER0_SUPPLIER_CA=${PWD}/organizations/peerOrganizations/supplier.supplychain.com/tlsca/tlsca.supplier.supplychain.com-cert.pem
export PEER0_MANUFACTURER_CA=${PWD}/organizations/peerOrganizations/manufacturer.supplychain.com/tlsca/tlsca.manufacturer.supplychain.com-cert.pem
export PEER0_DISTRIBUTOR_CA=${PWD}/organizations/peerOrganizations/distributor.supplychain.com/tlsca/tlsca.distributor.supplychain.com-cert.pem
export PEER0_RETAILER_CA=${PWD}/organizations/peerOrganizations/retailer.supplychain.com/tlsca/tlsca.retailer.supplychain.com-cert.pem
export PEER0_CONSUMER_CA=${PWD}/organizations/peerOrganizations/consumer.supplychain.com/tlsca/tlsca.consumer.supplychain.com-cert.pem
export ORDERER_ADMIN_TLS_SIGN_CERT=${PWD}/organizations/ordererOrganizations/supplychain.com/orderers/orderer.supplychain.com/tls/server.crt
export ORDERER_ADMIN_TLS_PRIVATE_KEY=${PWD}/organizations/ordererOrganizations/supplychain.com/orderers/orderer.supplychain.com/tls/server.key

# Set environment variables for the peer org
setGlobals() {
  local USING_ORG=""
  if [ -z "$OVERRIDE_ORG" ]; then
    USING_ORG=$1
  else
    USING_ORG="${OVERRIDE_ORG}"
  fi
  infoln "Using organization ${USING_ORG}"
  if [ $USING_ORG = supplier ]; then
    export CORE_PEER_LOCALMSPID="SupplierMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_SUPPLIER_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/supplier.supplychain.com/users/Admin@supplier.supplychain.com/msp
    export CORE_PEER_ADDRESS=localhost:7051

  elif [ $USING_ORG = manufacturer ]; then
    export CORE_PEER_LOCALMSPID="ManufacturerMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_MANUFACTURER_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/manufacturer.supplychain.com/users/Admin@manufacturer.supplychain.com/msp
    export CORE_PEER_ADDRESS=localhost:7061

  elif [ $USING_ORG = distributor ]; then
    export CORE_PEER_LOCALMSPID="DistributorMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_DISTRIBUTOR_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/distributor.supplychain.com/users/Admin@distributor.supplychain.com/msp
    export CORE_PEER_ADDRESS=localhost:7071

  elif [ $USING_ORG = retailer ]; then
    export CORE_PEER_LOCALMSPID="RetailerMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_RETAILER_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/retailer.supplychain.com/users/Admin@retailer.supplychain.com/msp
    export CORE_PEER_ADDRESS=localhost:7081
  
  elif [ $USING_ORG = consumer ]; then
    export CORE_PEER_LOCALMSPID="ConsumerMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_CONSUMER_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/consumer.supplychain.com/users/Admin@consumer.supplychain.com/msp
    export CORE_PEER_ADDRESS=localhost:7091

  else
    errorln "ORG Unknown"
  fi

  if [ "$VERBOSE" = "true" ]; then
    env | grep CORE
  fi
}

# Set environment variables for use in the CLI container
setGlobalsCLI() {
  setGlobals $1

  local USING_ORG=""
  if [ -z "$OVERRIDE_ORG" ]; then
    USING_ORG=$1
  else
    USING_ORG="${OVERRIDE_ORG}"
  fi
  if [ $USING_ORG = supplier ]; then
    export CORE_PEER_ADDRESS=peer0.supplier.supplychain.com:7051
  elif [ $USING_ORG = manufacturer ]; then
    export CORE_PEER_ADDRESS=peer0.manufacturer.supplychain.com:7061
  elif [ $USING_ORG = distributor ]; then
    export CORE_PEER_ADDRESS=peer0.distributor.supplychain.com:7071
  elif [ $USING_ORG = retailer ]; then
    export CORE_PEER_ADDRESS=peer0.retailer.supplychain.com:7081
  elif [ $USING_ORG = consumer ]; then
    export CORE_PEER_ADDRESS=peer0.consumer.supplychain.com:7091
  else
    errorln "ORG Unknown"
  fi
}

# parsePeerConnectionParameters $@
# Helper function that sets the peer connection parameters for a chaincode
# operation
parsePeerConnectionParameters() {
  PEER_CONN_PARMS=()
  PEERS=""
  while [ "$#" -gt 0 ]; do
    setGlobals $1
    PEER="peer0.$1"
    ## Set peer addresses
    if [ -z "$PEERS" ]
    then
	PEERS="$PEER"
    else
	PEERS="$PEERS $PEER"
    fi
    PEER_CONN_PARMS=("${PEER_CONN_PARMS[@]}" --peerAddresses $CORE_PEER_ADDRESS)
    ## Set path to TLS certificate
    CA=PEER0_${1^^}_CA
    TLSINFO=(--tlsRootCertFiles "${!CA}")
    PEER_CONN_PARMS=("${PEER_CONN_PARMS[@]}" "${TLSINFO[@]}")
    # shift by one to get to the next organization
    shift
  done
}

verifyResult() {
  if [ $1 -ne 0 ]; then
    fatalln "$2"
  fi
}
