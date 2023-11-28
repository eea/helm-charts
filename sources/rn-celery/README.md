# Reportnet Celery worker

Consume vanilla RabbitMQ messages or Celery tasks.

Celery is an open source asynchronous task queue/job queue based on distributed message passing. It is focused on real-time operation, but supports scheduling as well.

This application allows you to run a Celery worker together with your custom **Python dependencies**
by passing **requirements** and **contraints** via environment variables `REQUIREMENTS` respectively `CONSTRAINTS`.
It also has the ability to consume **vanilla AMQP messages** (i.e. **not** Celery tasks) based on
[celery-message-consumer](https://pypi.org/project/celery-message-consumer/)

[See more](https://github.com/eea/eea.docker.celery)

## Configuration

- `rabbitHost` - RabbitMQ hostname where from to consume messages
- `rabbitUser` - RabbitMQ client user name
- `rabbitPass` - RabbitMQ client password
- `requirements` - Python packages to install at load time (see more about [requirements.txt](https://pip.pypa.io/en/stable/user_guide/#requirements-files))
- `constraints` - Python packages versions pins (see more about [constraints.txt](https://pip.pypa.io/en/stable/user_guide/#constraints-files))
- `tasks` - Python code to run your tasks (see [tasks](https://github.com/eea/eea.docker.celery#run-with-docker-compose) example)
- `maxRetries` - How many times should Celery retry a job until mark it as failed.
- `archiveExpiry` - Time in milliseconds to keep the history of the failed jobs.
- `timezone` - Time zone.
- `useRedis` - If the tasks will use Redis.
- `redisHost` - Name of the Redis host. If it doesn't exist then one will be created.

## Releases

<dl>

  <dt>Version 0.1.1</dt>
  <dd>Some numeric values shall be interpreted as string.</dd>

  <dt>Version 0.1.0</dt>
  <dd>Initial release.</dd>

</dl>
