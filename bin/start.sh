#!/bin/bash

echo "[start.sh] Running Bundle install"
bundle install --with=development test

# Migrate the database first
echo "[start.sh] Migrating the database before starting the server"
bundle exec rake db:migrate

# Start Gunicorn processes
echo "[start.sh] Starting Gunicorn."
bundle exec unicorn config.ru

