# Rancher to Redmine wiki manager
Exports multiple rancher hosts, stacks and containers information to tables in wiki pages in Redmine. 

## Prerequisite

You need to generate an API key in every rancher from a readonly user. Also, the redmine user needs to have permission on the project to update wiki pages. 

## Stack Variables


1. Rancher configuration - can be multiple lines, each representing a rancher, with the format - rancher url, access key, secret key ( separated by commas)
2. Redmine url - The main url of the redmine instance
3. Redmine API key - Belongs to the user that will update the wiki pages
4. Redmine wiki project - The redmine project where the wiki pages are
5. Redmine wiki hosts page 
6. Redmine wiki stacks page  
7. Redmine wiki containers page 
8. Debug on - Choose Yes to enable debug logging
9. Crontab schedule (UTC) - uses https://godoc.org/github.com/robfig/cron#hdr-CRON_Expression_Format
10.  Timezone 


## Usage

The stack needs a rancher_crontab stack to start it according to the Run Schedule, otherwise it will only run once. If you do not set all of the Redmine related variables, the generated pages will be written in docker logs. 


## Releases

### Version 1.4.0 - 11 August 2025
- Automated release of [eeacms/redmine-wikiman:2.1.2](https://github.com/eea/eea.docker.redmine-wikiman/releases) [EEA Jenkins - [`86a44524`](https://github.com/eea/helm-charts/commit/86a44524aa10db42689aeb4546861ae441702819)]

### Version 1.3.0 - 31 July 2025
- Automated release of [eeacms/redmine-wikiman:2.1.1](https://github.com/eea/eea.docker.redmine-wikiman/releases) [EEA Jenkins - [`365738a0`](https://github.com/eea/helm-charts/commit/365738a0b846e221d4feff7fdcd1e0ece4ff0332)]

### Version 1.2.0 - 21 July 2025
- Automated release of [eeacms/redmine-wikiman:2.1](https://github.com/eea/eea.docker.redmine-wikiman/releases) [EEA Jenkins - [`e521549f`](https://github.com/eea/helm-charts/commit/e521549f6491ffffdcac38c82603e2c50151b247)]


### Version 1.1.2
- Add limits to keep pods history

### Version 1.1.0
- Add volume to keep GIT directory between runs

### Version 1.0.0
- First production release 



