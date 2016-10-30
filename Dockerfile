FROM ruby:2.3
RUN gem update --system ; gem update ; mkdir /on-zero-load
WORKDIR /on-zero-load
ADD on-zero-load.gemspec Gemfile Gemfile.lock /on-zero-load/
RUN bundle install -j4
ADD . /on-zero-load
