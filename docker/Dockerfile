FROM ruby:3.2.1

RUN apt-get update -qq && apt-get install -y nodejs postgresql-client cron
RUN mkdir /myapp
WORKDIR /myapp
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN gem update --system && gem install bundler
RUN bundle install

# Just for a better reading
COPY . /myapp

RUN mkdir -p /mpapp/health_check_files/pids

COPY /docker/startup.sh /usr/bin/
RUN chmod +x /usr/bin/startup.sh

COPY /docker/prepare-db.sh /usr/bin/
RUN chmod +x /usr/bin/prepare-db.sh

COPY /docker/prepare-cron-jobs.sh /usr/bin/
RUN chmod +x /usr/bin/prepare-cron-jobs.sh

ENTRYPOINT ["/usr/bin/startup.sh"]
EXPOSE 3000

CMD ["bundle", "exec", "rails", "s", "-b", "0.0.0.0"]
