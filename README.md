# Code challenge
Spin uses a lot of services, we want you challenge you implement a monitoring server, the challenge consists of collecting metrics in real time and finding a way to visualize data collected.

### Setup and requirements

- Create a github repository so we can fork and review it.
- Push code regularly with meaningful commit messages.
- Tests are required, though not at 100% coverage.
- Test enough to make you confident that the feature will work. Use your best judgement here. If you think of edge cases, include them as you see fit!
- When done, invite `<github user provider by recruiter>` to your github repo and email your recruiter that you did.

### Challenge details

Your application is required to collect server metrics in real time. We'll provide you with an agent (found under `/testing-scripts/`) that will send metrics requests (from several servers) to your endpoints, your challenge is to:

1. collect these metrics in real time using the agent
2. build an endpoint to create threshold alerts
4. when an alert is triggered send an email to `<user provided from recruiter>@spin.pm` with corresponding information.
5. build an endpoint to change alert status (open, acknowledged, resolved)


### Testing agent
Under the `testing-script/` folder you'll find a compiled agent for different platforms. If none of these works for your OS, please consider running it within a docker container.

Once you run the agent you will start to see requests to the given URLs, that's all you need from these agents. To understand how this agent works, run `./testing-script/agent-<os> -h`

### Docker

If you prefer not to install services locally, you can use `docker-compose.yml`.

#### Build images

```
docker-compose build
```

#### Setup database

```
docker-compose run web rails db:drop db:setup
```

#### Run agent foom a docker container

```
docker-compose up agent
```


#### Enter web container and possibly run rails console (or if installed rspec)

start service

```
docker-compose up
```

Enter web container

```
docker-compose exec web bash
```

Start rails console and then you can run

```
rails console
```
