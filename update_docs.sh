#!/bin/sh

if [ -z "$1" ] || [ ! -d sources/$1 ]; then
    echo "Please give the paramater the directory from sources"
    exit 1
fi

git pull


echo "Starting release on $1"
cd sources/$1
version=$(grep "version:" Chart.yaml | awk -F":" '{print $2}')
echo "Version is $version"

echo "Continue? Enter for yes"
read variable
if [ -n "$variable" ]; then
	exit 1
fi

helm lint .
if [ $(grep "repository" Chart.yaml | wc -l ) -ne 0 ]; then
   echo "Updating dependecies"
   helm dependencies update 
fi

cd ../../docs
mkdir -p temp
cd temp
helm package ../../sources/$1
helm repo index --merge ../index.yaml .
mv * ../
cd ..
rm temp


cd ..
git diff docs/index.yaml
git add sources/$1
git add docs/

git status

echo "Git commit & push? Enter for yes"
read variable
if [ -z "$variable" ]; then
	git commit -m "Release on $1 version $version"
	git push
fi





