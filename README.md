# Catalog for Helm charts

## Usage

The principles are taken from [Mattia Peri](https://medium.com/@mattiaperi/create-a-public-helm-chart-repository-with-github-pages-49b180dbb417). We commit directly to the Master or Main branch in the /docs folder. This is then published on GitHub Pages.

To add a chart do:

    git clone https://github.com/eea/helm-charts.git

Create your package or update the source. For the example we will call the package `toypackage`.

    cd helm-charts/sources
    mkdir toypackage _or helm create toypackage_
    cd toypackage
    _... create Chart.yaml, values.yaml etc. If updating, remember to increase version number in Chart.yaml_

Check package:

    helm lint .

_Might raise errors if dependencies were changed. If that happens, run __helm dependencies update__ first_

Update dependecies:

    helm dependencies update 
    
_if you have changed the chart dependencies_


Update Readme/Version Increase:

After you did some changes in an existing helm chart, don't commit yet, use the `increase_version_helm.sh` to prepare to release a new version of helm chart

Variables:

* `HELM_VERSION_TYPE` - increases the current version of the chart with  "MINOR", "MAJOR", "PATCH", default "PATCH" 
* `HELM_UPGRADE_MESSAGE` - mandatory, changelog message that will be put in README.md
* `HELM_ADD_COMMIT_LINK_README` - will first create a commit with the changes in the chart, then add the commit link in the README, together with the author of the commit, default "yes"
* `HELM_COMMIT_MESSAGE` - used in case you want to use a different commit message than the one in README.md, defaults to `HELM_UPGRADE_MESSAGE`


   cd sources/toypackage
   
   HELM_UPGRADE_MESSAGE="Added a new variable in values.yaml" ../../increase_version_helm.sh  

This will first do a commit with your changes and the message "Added a new variable in values.yaml".
Then it will "PATCH" increase the Chart version  0.1.1 -> 0.1.2, 1.2.9 -> 1.2.10, etc
Then it will add a changelog entry in README.md file with the following structure:

    ## Releases

    ### Version NEW_VERSION - DATE
    - HELM_UPGRADE_MESSAGE [AUTHOR - [`COMMIT`](COMMIT_LINK)]





Update/Release docs:

Can be called by the name or the path of the chart directory:

    ./update_docs.sh toypackage

or

    ./update_docs.sh sources/toypackage


The script does:

    git pull
    git add .
    cd ../../docs
    mkdir temp
    cd temp
    helm package ../../sources/toypackage
    helm repo index --merge ../index.yaml .
    mv * ../
    cd ..
    rmdir temp
    git add .
    git commit
    git push


## Subcharts update after release

If you manually released a chart that is also used as a subchart in another chart, you can use this script to update all helm charts from sources directory that contain it:

    ./release_subchart.sh sources/YOUR_NEWLY_RELEASED_CHART



## Deploying Helm charts

In Rancher 2 you can add the repository to the cluster and it will show the packages on a list. You can then select the version to install or upgrade to.

On the command line you can do the same with the helm tool.

    helm add repo eea-charts https://eea.github.io/helm-charts/

## Source repository

The sources for these pages are located at the [GitHub project](https://github.com/eea/helm-charts).
