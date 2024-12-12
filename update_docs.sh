#!/bin/bash

set -e

chart="$1"
if [[ $1 == sources/* ]]; then 
	chart=$(echo $1 | awk -F'/' '{print $2}')
fi


if [ -z "$chart" ] || [ ! -d sources/$chart ]; then
    echo "Please give the parameter the directory from sources"
    exit 1
fi

git pull


echo "Starting release on $chart"
cd sources/$chart
version=$(grep "^version:" Chart.yaml | head -n 1 | awk -F":" '{print $2}')
echo "Version is $version"

echo "Continue? Enter for yes"
read variable
if [ -n "$variable" ]; then
	exit 1
fi

helm lint .
if [ $(grep "repository" Chart.yaml | wc -l ) -ne 0 ]; then
   echo "Updating dependencies"
   helm dependencies update 
fi

cd ../../docs
mkdir -p temp
cd temp
helm package ../../sources/$chart
helm repo index --merge ../index.yaml .
mv * ../
cd ..
rm -rf temp


cd ..
git diff docs/index.yaml
git add sources/$chart
git add docs/

git status

echo "Git commit & push? Enter for yes"
read variable
if [ -z "$variable" ]; then
	git commit -m "Release on $chart version $version"
	git push
fi





