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

Update dependecies:
    helm dependencies update _if you have changed the chart dependencies_

Update/Release docs:

    ./update_docs.sh toypackage

or

    git pull
    git add .
    cd ../../docs
    mkdir -p temp
    cd temp
    helm package ../../sources/toypackage
    helm repo index --merge ../index.yaml .
    mv * ../
    cd ..
    rm temp
    git add .
    git commit
    git push

## Deploying Helm charts

In Rancher 2 you can add the repository to the cluster and it will show the packages on a list. You can then select the version to install or upgrade to.

On the command line you can do the same with the helm tool.

    helm add repo eea-charts https://eea.github.io/helm-charts/

## Source repository

The sources for these pages are located at the [GitHub project](https://github.com/eea/helm-charts).
