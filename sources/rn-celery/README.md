# Reportnet Celery worker

Consume vanilla RabbitMQ messages or Celery tasks.

Celery is an open source asynchronous task queue/job queue based on distributed message passing. It is focused on real-time operation, but supports scheduling as well.

This application allows you to run multiple Celery workers together with your custom **Python dependencies** by passing **requirements** and **constraints** via environment variables. It also has the ability to consume **vanilla AMQP messages** (i.e. **not** Celery tasks) based on [celery-message-consumer](https://pypi.org/project/celery-message-consumer/)

[See more](https://github.com/eea/eea.docker.celery)

## Configuration

### Global Settings

- `rabbitHost` - RabbitMQ hostname where from to consume messages
- `rabbitUser` - RabbitMQ client user name
- `rabbitPass` - RabbitMQ client password
- `rabbitNS` - RabbitMQ namespace (optional)
- `timezone` - Time zone for the workers
- `requirements` - Default Python packages to install (see more about [requirements.txt](https://pip.pypa.io/en/stable/user_guide/#requirements-files))
- `constraints` - Default Python packages versions pins (see more about [constraints.txt](https://pip.pypa.io/en/stable/user_guide/#constraints-files))
- `archiveExpiry` - Time in milliseconds to keep the history of the failed jobs
- `maxRetries` - How many times should Celery retry a job until mark it as failed
- `envVars` - Global environment variables for all workers
- `podSecurityContext` - Pod security context
- `nodeSelector` - Node selector rules
- `tolerations` - Pod tolerations
- `affinity` - Pod affinity rules

### Redis Settings

- `redis.enabled` - Enable Redis support
- `redis.host` - Redis hostname
- `redis.create` - Create a Redis instance (if enabled)
- `redis.resources` - Redis pod resource requirements
- `redis.securityContext` - Redis pod security context

### Worker Settings

Workers can be defined in the `workers` list, where each worker can have:

- `name` - Worker name (required)
- `tasks` - Python code defining the tasks (inline)
- `tasksFile` - Path to Python file containing tasks (alternative to inline tasks)
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
- `credentials` - Worker-specific platform credentials configuration
- `podDisruptionBudget` - PodDisruptionBudget configuration
- `terminationGracePeriodSeconds` - Grace period for pod termination (default: 30)
- `livenessProbe` - Container liveness probe configuration
- `readinessProbe` - Container readiness probe configuration
- `podAnnotations` - Pod annotations

## Examples

### Basic Worker Configuration

```yaml
workers:
  - name: ping-worker
    tasksFile: "tasks/ping_task.py"  # Using external task file
    replicas: 2
    envVars:
      - name: QUEUE
        value: "ping_queue"
    resources:
      requests:
        memory: "256Mi"
      limits:
        memory: "512Mi"

  - name: qa-worker
    # Inline task definition
    tasks: |
      @app.task
      def process_qa(data):
          print("Processing QA data: {}".format(data))
          return True
    replicas: 1
    maxRetries: 5
```

### Credentials Configuration

Credentials can be configured in two ways:

1. Using secrets in values.yaml:

```yaml
secrets:
  cdrdev:
    user: "testusername"
    pass: "testpassword"
  bdr-test:
    user: "testuser"
    pass: "testpass"

workers:
  - name: sync-worker
    tasksFile: "tasks/collections_sync_task.py"
    credentials:
      - envPrefix: "CDR"
        envName: "DEV"
        deployment: "cdrdev"
      - envPrefix: "BDR"
        envName: "TEST"
        deployment: "bdr-test"
```

This will create environment variables:
- CDR_DEV_USER and CDR_DEV_PASS for cdrdev credentials
- BDR_TEST_USER and BDR_TEST_PASS for bdr-test credentials

2. Using existing secrets:

```yaml
workers:
  - name: sync-worker
    envVars:
      - name: CDR_DEV_USER
        valueFrom:
          secretKeyRef:
            name: existing-secret
            key: cdr-username
      - name: CDR_DEV_PASS
        valueFrom:
          secretKeyRef:
            name: existing-secret
            key: cdr-password
```

## Releases
### Version 0.2.2
- Fixed tasks redis port reading from env vars

### Version 0.2.1
- Added missing deployment in fwd_envelopes_task

### Version 0.2.0
- Added support for defining tasks in external Python files with `tasksFile`
- Enhanced documentation with examples

### Version 0.1.2
- Added support for multiple workers
- Added podDisruptionBudget
- Added terminationGracePeriodSeconds
- Refactored redis templates and values

### Version 0.1.1
- Fixed numeric values interpretation as strings

### Version 0.1.0
- Initial release
