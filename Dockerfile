FROM ruby:2.6.5

RUN apt-get update && apt-get install -y \
  build-essential \
  ruby-mysql2

ENV APP_HOME /app
RUN mkdir $APP_HOME

WORKDIR $APP_HOME

ADD Gemfile* $APP_HOME/
RUN cd $APP_HOME && bundle update && bundle install --without development test

ADD . $APP_HOME

EXPOSE 4567

CMD ["bundle", "exec", "rackup", "--host", "0.0.0.0"]
