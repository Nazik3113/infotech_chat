FROM elixir:1.16.1-alpine as releaser

WORKDIR /app

RUN mix do local.hex --force, local.rebar --force

ENV MIX_ENV=prod

COPY mix.* /app/

RUN mix do deps.get --only $MIX_ENV, deps.compile

COPY . /app/

RUN MIX_ENV=prod mix compile

RUN MIX_ENV=prod REPLACE_OS_VARS=true mix release

FROM alpine:3.21.0

RUN apk upgrade --no-cache && \
    apk add --no-cache bash openssl libgcc libstdc++ ncurses-libs && \
    apk add -U bash

EXPOSE 8002
EXPOSE 8004

ARG APP_VERSION=0.1.1

ENV APP_VERSION=${APP_VERSION}
ENV MIX_ENV=prod
ENV SHELL=/bin/bash
ENV REPLACE_OS_VARS=true

WORKDIR /app

COPY --from=releaser /app/_build/prod/rel/infotech_chat .
COPY --from=releaser /app/priv/static /app/priv/static

CMD ["/app/bin/infotech_chat", "start"]
