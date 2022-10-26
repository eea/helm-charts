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
