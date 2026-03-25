#!/bin/bash

echo "Manual release script starting"

#check modified or new files:

if [ $( git diff . | wc -l ) -gt 0 ] || [ $( git ls-files . --exclude-standard --others | wc -l ) -gt 0 ] ; then



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


CI=true ../../update_docs.sh


unset HELM_VERSION_TYPE

else

	echo "There are no files to update !"
	echo "Please run this script without adding the files in git ( neither 'git add' nor 'git commit')"
	git status
        git diff
fi


