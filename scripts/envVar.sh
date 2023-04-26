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
export ORDERER_CA=${PWD}/organizations/ordererOrganizations/scm.com/tlsca/tlsca.scm.com-cert.pem
export PEER0_SUPPLIER_CA=${PWD}/organizations/peerOrganizations/supplier.scm.com/tlsca/tlsca.supplier.scm.com-cert.pem
export PEER0_MANUFACTURER_CA=${PWD}/organizations/peerOrganizations/manufacturer.scm.com/tlsca/tlsca.manufacturer.scm.com-cert.pem
export PEER0_DISTRIBUTOR_CA=${PWD}/organizations/peerOrganizations/distributor.scm.com/tlsca/tlsca.distributor.scm.com-cert.pem
export PEER0_RETAILER_CA=${PWD}/organizations/peerOrganizations/retailer.scm.com/tlsca/tlsca.retailer.scm.com-cert.pem
export ORDERER_ADMIN_TLS_SIGN_CERT=${PWD}/organizations/ordererOrganizations/scm.com/orderers/orderer.scm.com/tls/server.crt
export ORDERER_ADMIN_TLS_PRIVATE_KEY=${PWD}/organizations/ordererOrganizations/scm.com/orderers/orderer.scm.com/tls/server.key

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
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/supplier.scm.com/users/Admin@supplier.scm.com/msp
    export CORE_PEER_ADDRESS=localhost:7051

  elif [ $USING_ORG = manufacturer ]; then
    export CORE_PEER_LOCALMSPID="ManufacturerMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_MANUFACTURER_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/manufacturer.scm.com/users/Admin@manufacturer.scm.com/msp
    export CORE_PEER_ADDRESS=localhost:7061

  elif [ $USING_ORG = distributor ]; then
    export CORE_PEER_LOCALMSPID="DistributorMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_DISTRIBUTOR_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/distributor.scm.com/users/Admin@distributor.scm.com/msp
    export CORE_PEER_ADDRESS=localhost:7071

  elif [ $USING_ORG = retailer ]; then
    export CORE_PEER_LOCALMSPID="RetailerMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_RETAILER_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/retailer.scm.com/users/Admin@retailer.scm.com/msp
    export CORE_PEER_ADDRESS=localhost:7081

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
    export CORE_PEER_ADDRESS=peer0.supplier.scm.com:7051
  elif [ $USING_ORG = manufacturer ]; then
    export CORE_PEER_ADDRESS=peer0.manufacturer.scm.com:7061
  elif [ $USING_ORG = distributor ]; then
    export CORE_PEER_ADDRESS=peer0.distributor.scm.com:7071
  elif [ $USING_ORG = retailer ]; then
    export CORE_PEER_ADDRESS=peer0.retailer.scm.com:7081
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
