#!/bin/bash

set -e

command -v yq >/dev/null 2>&1 || { echo "yq is required but not installed. Install it from https://github.com/mikefarah/yq?tab=readme-ov-file#install"; exit 1; }


if [ ! -f Chart.yaml ]; then

	echo "Please run this script inside a helm chart directory !!!!"
	echo "Exiting"
	exit 1
fi

if  [ $(git diff . | wc -l ) -eq 0 ]; then
	echo "There is nothing to modify!"
	exit 0
fi

if [ $# -eq 1 ]; then
	HELM_VERSION_TYPE=$1
fi

if [[ ! "$HELM_VERSION_TYPE" == "MINOR" ]] && [[ ! "$HELM_VERSION_TYPE" == "MAJOR" ]]; then
    HELM_VERSION_TYPE="PATCH"
fi

if [ -z "$HELM_UPGRADE_MESSAGE" ] && [ -n "$CI" ]; then
        echo "DID NOT receive HELM_UPGRADE_MESSAGE parameter. It's mandatory for README.md and commit"
        echo "Exiting"
        exit 1
fi

while [ -z "$HELM_UPGRADE_MESSAGE" ] ; do

	  echo "Write HELM_UPGRADE_MESSAGE message"
	  read HELM_UPGRADE_MESSAGE 
	  echo "Message is $HELM_UPGRADE_MESSAGE"
	  echo "Ok? anything to read again the commit message"
	  read y
	  if [ -n "$y" ]; then
              unset HELM_UPGRADE_MESSAGE
          fi
done

HELM_COMMIT_MESSAGE="${HELM_COMMIT_MESSAGE:-$HELM_UPGRADE_MESSAGE}"
HELM_ADD_COMMIT_LINK_README="${HELM_ADD_COMMIT_LINK_README:-yes}"

echo "Found differences, will now start the version increase"
echo "HELM_VERSION_TYPE is $HELM_VERSION_TYPE"
echo "Version will be increased with $HELM_VERSION_TYPE"
echo "Readme message is $HELM_UPGRADE_MESSAGE"
echo "Commit message is $HELM_COMMIT_MESSAGE"

readme_link=""

git pull

helm lint .

if [[ "$HELM_ADD_COMMIT_LINK_README" == "yes" ]]; then
  echo "Will now create a commit only with the changes in the chart used in Changelog"
  git add .
  git commit -m "$HELM_COMMIT_MESSAGE"
  commit=$(git rev-parse HEAD)
  url=$(git config --get remote.origin.url | sed 's|.*github.com[:/]|https://github.com/|' | sed 's|.git$||')/commit/$commit
  readme_link='['$(git log -1 --pretty=format:'%an')' - [`'$(git rev-parse --short HEAD)'`]('$url')]'

fi






old_version=$(yq -r '.version' Chart.yaml )

v1=$(echo "$old_version" | awk -F. '{print $1}' )
v2=$(echo "$old_version" | awk -F. '{print $2}' )
v3=$(echo "$old_version" | awk -F. '{print $3}' )

if [[ "$HELM_VERSION_TYPE" == "PATCH" ]]; then
   let v3=$v3+1
fi

if [[ "$HELM_VERSION_TYPE" == "MINOR" ]]; then
   let v2=$v2+1
   v3="0"
fi

if [[ "$HELM_VERSION_TYPE" == "MAJOR" ]]; then
   let v1=$v1+1
   v2="0"
   v3="0"
fi


echo "Old version is $old_version, new version is $v1.$v2.$v3 "

HELM_NEWVERSION="${v1}.${v2}.${v3}"

if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS (BSD sed)
    echo "Running on macOS"
    SED_INPLACE=(-i '')
else
    # Linux (GNU sed)
    echo "Running on Linux"
    SED_INPLACE=(-i)
fi


sed "${SED_INPLACE[@]}" "s/^version:.*/version: $HELM_NEWVERSION/g" Chart.yaml


line=$(grep -nE "^#+ Releases" README.md | awk -F: '{print $1}')

if [ -z "$line" ]; then

	echo "ERROR Could not find section with Releases in README.md file"
	exit 1
 
fi


sed "1,${line}d" README.md > part2

if [ $(grep "<dl>" part2 | wc -l ) -eq 1 ]; then
    sed "${SED_INPLACE[@]}" 's|<[/]*dl>.*||g' part2
    sed "${SED_INPLACE[@]}"  's|[ ]*<dt>\(.*\)</dt>|### \1|g' part2
    sed "${SED_INPLACE[@]}"  's|[ ]*<dd>\(.*\)</dd>|- \1|g' part2
fi


head -n $line README.md > part1

echo -e "\n### Version $HELM_NEWVERSION - $(LANG=en_us_88591 date +"%d %B %Y")\n- $HELM_UPGRADE_MESSAGE $readme_link" | sed 's/[Rr][Ee][Ff][Ss][ ]*#\([0-9]*\)/Refs \[#\1\]\(https:\/\/taskman.eionet.europa.eu\/issues\/\1\)/g' >> part1


cat part1 part2 > README.md

rm part1 part2

echo "Updated README.md with:"

git diff README.md

export HELM_NEWVERSION



