FROM ruby:3.4

RUN gem install bundler

WORKDIR /app

COPY . .
RUN bundle install
