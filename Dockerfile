FROM ruby:3.1-slim

RUN apt update -q && \
    apt install -qy \
    build-essential \
    libpq-dev \
    libvips \
    glibc-source \
    --no-install-recommends && \
    apt clean

WORKDIR /code

COPY Gemfile ./
COPY Gemfile.lock ./

RUN bundle install

COPY . .

ENTRYPOINT ["bundle", "exec"]
