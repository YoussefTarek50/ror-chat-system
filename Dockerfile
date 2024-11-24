# syntax = docker/dockerfile:1

# This Dockerfile is designed for production, not development. Use with Kamal or build'n'run by hand:
# docker build -t my-app .
# docker run -d -p 80:80 -p 443:443 --name my-app -e RAILS_MASTER_KEY=<value from config/master.key> my-app

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version
ARG RUBY_VERSION=3.1.2
FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base

# Set environment variables
ENV RAILS_ENV="development" \
    BUNDLE_PATH="/bundle" \
    PATH=/app/bin:$PATH

## Install dependencies
RUN apt-get update -qq && apt-get install -y \
    wget \
    build-essential \
    libpq-dev \
    libmariadb-dev \
    nodejs \
    postgresql-client && \
    # Install dockerize
    wget https://github.com/jwilder/dockerize/releases/download/v0.6.1/dockerize-linux-amd64-v0.6.1.tar.gz && \
    tar -xvzf dockerize-linux-amd64-v0.6.1.tar.gz && \
    mv dockerize /usr/local/bin/

# Install the required version of bundler globally
RUN gem install bundler -v '~> 2.5'

# Create app directory
WORKDIR /app

# Install gems
COPY Gemfile Gemfile.lock /app/
RUN bundle install

# Copy application files
COPY . /app

# Expose Rails default port
EXPOSE 3000

# Start the server
CMD dockerize -wait tcp://elasticsearch:9200 -timeout 120s /app/bin/rails server -b '0.0.0.0'