FROM ruby:2.3
MAINTAINER Luis Ernesto Gil Castellanos <luegilca@unal.edu.co>

RUN mkdir /download_ms
WORKDIR /download_ms

ADD Gemfile /download_ms/Gemfile
ADD Gemfile.lock /download_ms/Gemfile.lock

RUN bundle install
ADD . /download_ms