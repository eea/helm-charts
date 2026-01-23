#!/bin/bash

echo "Manual release script starting"


if [ -z "$HELM_VERSION_TYPE" ]; then

  echo "Did not receave the HELM_VERSION_TYPE parameter"
  echo "Choose type of release:"
  echo " 1. PATCH - DEFAULT - for small changes, fixes"
  echo " 2. MINOR - for a significant upgrade, like a new release of the main container docker image"
  echo " 3. MAJOR - for breaking changes, important updates that provide the biggest change"
  read type

  if [[ "$type" == "2" ]]; then
export    HELM_VERSION_TYPE="MINOR"
  fi
  if [[ "$type" == "3" ]]; then
export    HELM_VERSION_TYPE="MAJOR"
  fi

fi



../../increase_version_helm.sh


../../update_docs.sh
