# Catalog for Helm charts

## Usage

The principles are taken from [Mattia Peri](https://medium.com/@mattiaperi/create-a-public-helm-chart-repository-with-github-pages-49b180dbb417). We commit directly to the Master or Main branch.

To add a chart do:

    git clone https://github.com/eea/helm-charts.git
    cd helm-charts/sources

Create your package or update the source, then

    cd ..
    helm package sources
    helm repo index --url https://eea.github.io/helm-charts/ .
    git add .
    git commit
    git push

## Deploying Helm charts

In Rancher 2.6 you can add the repository to the cluster and it will show the packages on a list. You can then select the version to install or upgrade to.

On the command line you can do the same with the helm tool.

    helm add repo eea-charts https://eea.github.io/helm-charts/

## Source repository

The sources for these pages are located at the [GitHub project](https://github.com/eea/helm-charts).
