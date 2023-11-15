#! /bin/sh

# update cron jobs
bundle exec whenever --update-crontab --set 'environment=development'

echo "cron jobs updated successfully!"
