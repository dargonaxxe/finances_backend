FROM elixir:1.15.6-slim

ENV DATABASE_NAME=database \
    DATABASE_USERNAME=username \
    DATABASE_PASSWORD=password \
    DATABASE_HOSTNAME=hostname

WORKDIR "app/"
RUN mix local.hex --force --if-missing && \
    mix local.rebar --force --if-missing

COPY mix.exs mix.lock ./
RUN mix deps.get && \
    mix deps.compile

COPY . .
CMD ["iex", "-S", "mix"]


