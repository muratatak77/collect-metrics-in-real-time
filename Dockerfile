FROM ruby:2.7.2-slim

RUN apt-get update -qq && apt-get install --fix-missing -y build-essential libpq-dev postgresql-client

WORKDIR /app

COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock

RUN bundle install

COPY . /app

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]

