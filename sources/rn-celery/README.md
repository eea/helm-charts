# Reportnet Celery worker

Consume vanilla RabbitMQ messages or Celery tasks.

Celery is an open source asynchronous task queue/job queue based on distributed message passing. It is focused on real-time operation, but supports scheduling as well.

This application allows you to run multiple Celery workers together with your custom **Python dependencies**
by passing **requirements** and **constraints** via environment variables. It also has the ability to consume **vanilla AMQP messages** (i.e. **not** Celery tasks) based on
[celery-message-consumer](https://pypi.org/project/celery-message-consumer/)

[See more](https://github.com/eea/eea.docker.celery)

## Configuration

### Global Settings

- `image.repository` - Docker image repository
- `image.tag` - Docker image tag (defaults to chart appVersion)
- `image.pullPolicy` - Image pull policy
- `rabbitHost` - RabbitMQ hostname where from to consume messages
- `rabbitUser` - RabbitMQ client user name
- `rabbitPass` - RabbitMQ client password
- `rabbitNS` - RabbitMQ namespace (optional)
- `timezone` - Time zone for the workers
- `requirements` - Default Python packages to install (see more about [requirements.txt](https://pip.pypa.io/en/stable/user_guide/#requirements-files))
- `constraints` - Default Python packages versions pins (see more about [constraints.txt](https://pip.pypa.io/en/stable/user_guide/#constraints-files))
- `archiveExpiry` - Time in milliseconds to keep the history of the failed jobs
- `maxRetries` - How many times should Celery retry a job until mark it as failed

### Redis Settings

- `redis.enabled` - Enable Redis support
- `redis.host` - Redis hostname
- `redis.create` - Create a Redis instance (if enabled)
- `redis.resources` - Redis pod resource requirements

### Worker Settings

Workers can be defined in the `workers` list, where each worker can have:

- `name` - Worker name (required)
- `tasks` - Python code defining the tasks (required)
- `replicas` - Number of worker replicas (default: 1)
- `requirements` - Worker-specific Python requirements (overrides global)
- `constraints` - Worker-specific Python constraints (overrides global)
- `maxRetries` - Worker-specific retry limit (overrides global)
- `archiveExpiry` - Worker-specific archive expiry (overrides global)
- `resources` - Worker-specific resource requirements
- `securityContext` - Worker-specific security context
- `affinity` - Worker-specific affinity rules
- `tolerations` - Worker-specific tolerations
- `envVars` - Additional environment variables
- `podDisruptionBudget` - PodDisruptionBudget configuration
- `terminationGracePeriodSeconds` - Grace period for pod termination (default: 30)

## Example

```yaml
workers:
  - name: ping
    tasks: |
      import urllib.request

      @message_handler("sds_queue")
      def ping(message):
          action, service, uri = message.split("|")
          url = "%s?uri=%s" % (service, uri)
          if action == 'create':
              url += "&create=True"

          # ... rest of the task code ...
```

## Releases

### Version 0.1.2
- Some refactoring to allow multiple workers
- Add podDisruptionBudget
- Add terminationGracePeriodSeconds
- Some refactoring of the redis templates and values

### Version 0.1.1
- Some numeric values shall be interpreted as string.

### Version 0.1.0
- Initial release.
