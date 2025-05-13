# EEA Screenshoteer service

Service for making web screenshots and pdfs via api.

Tool based on <a href="https://github.com/GoogleChrome/puppeteer">puppeteer</a>.

## Installation

<p><a href="https://hub.docker.com/r/eeacms/screenshoteer">Docker image</a>. </p>
<p><a href="https://github.com/eea/eea.docker.screenshoteer/blob/master/docker-compose.yml">Docker Compose</a>. </p>
<p><a href="https://eea.github.io/helm-charts/">Helm Chart</a>.</p>

## Releases

1.12.0 - Remove default capabilities

## API options

/API/v1/retrieve_image_for_url?params=params - used for image/pdf creation, returns the respective pdf/image as response

/API/v1/invalidate_cache_for_url?params=params - delete all entries for the respective url

/API/v1/recreate_cluster?params=params - recreate the puppeteer-cluster, use force=true in order to force recreation

/API/v1/create_image?params=params - used mainly by retrieve_image_for_url, not for public use

/API/v1/healthcheck - used mainly by rancher, returns code 200 if everything checks out
<p>

### API Parameters

--url - web page url

--emulate - emulate web device example: --emulate "iPhone 6"

--fullPage - can be true or false. It will take screenshot of entire web page if is true. True is the default parameter.

--pdf - generate additional pdf

--w - width of the Web Page in px

--h - height of the Web Page in px

--waitfor - wait time for the page load in milliseconds

--waitforselector - wait for the selector to appear in page

--el - css selector document.querySelector

--auth - basic http authentication

--no - exclude "image", "stylesheet", "script", "font"

--click - example: ".selector>a" excellent way to close popups or to click some buttons on the page.


## Example

```shell
/API/v1/retrieve_image_for_url?url=https://www.eea.europa.eu/countries-and-regions/hungary&pdf=true

/API/v1/retrieve_image_for_url?url=https://www.eea.europa.eu/themes/biodiversity/europe-protected-areas/designation-types-used-by-countries&pdf=true&waitfor=10000&fullPage=true

/API/v1/retrieve_image_for_url?url=google.com&fullPage=true&w=1920
```

List of of supported mobile devices: https://github.com/GoogleChrome/puppeteer/blob/master/DeviceDescriptors.js
