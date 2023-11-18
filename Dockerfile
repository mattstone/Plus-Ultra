FROM ruby:3.1.4-bullseye as base

RUN apt-get update -qq && apt-get install -y build-essential apt-utils libpq-dev  imagemagick libmagickwand-dev libvips ffmpeg nodejs

WORKDIR /docker/app

RUN gem install bundler

COPY Gemfile* ./
COPY .env /

RUN mkdir -p tmp/pids

RUN bundle install

ADD . /docker/app

ARG DEFAULT_PORT 3000

EXPOSE ${DEFAULT_PORT}

CMD [ "bundle","exec", "puma", "config.ru"] # CMD ["rails","server"] # you can also write like this.