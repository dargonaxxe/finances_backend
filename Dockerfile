FROM elixir:1.15.6-slim 

RUN apt-get update && apt-get install build-essential make -y
WORKDIR /app

RUN mix local.hex --force && mix local.rebar --force

COPY mix.exs mix.lock /app/ 
COPY apps/finances_backend/mix.exs apps/finances_backend/mix.lock /app/apps/finances_backend/
COPY apps/finances_web/mix.exs /app/apps/finances_web/
RUN mix deps.get && mix deps.compile

COPY . . 

RUN mix compile

ENTRYPOINT [ "iex", "-S", "mix" ]
