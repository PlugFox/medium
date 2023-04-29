# docker build . -t plugfox/medium:0.0.1
# docker run -it --rm -w /app -v ${PWD}/data:/app/data -p 8080:8080 plugfox/medium:0.0.1

# Use latest beta channel SDK.
FROM dart:beta AS build

# Resolve app dependencies.
WORKDIR /app
COPY pubspec.* ./
RUN dart pub get

# Copy app source code (except anything in .dockerignore) and AOT compile app.
COPY . .

RUN dart compile exe bin/server.dart -o bin/server && \
    dart compile exe bin/init.dart -o bin/init

# https://hub.docker.com/r/satantime/puppeteer-node
# docker run -it --rm --user root satantime/puppeteer-node:buster-slim /bin/bash
#FROM satantime/puppeteer-node:buster-slim as producation
FROM ubuntu:lunar as producation

# Install deps + add Chrome Stable + purge all the things
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends gnupg apt-transport-https \
    sqlite3 libsqlite3-dev locales wget ca-certificates curl lsb-release unzip

# Установите Google Chrome
#RUN apt-get update -y && \
#    apt-get install -y --no-install-recommends chromium-browser

RUN mkdir -p /app/data
COPY --from=build /app/bin/init /app/bin/
RUN /app/bin/init
RUN rm /app/bin/init

# Очистите кэш пакетов
RUN apt-get purge --auto-remove -y gnupg && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

#COPY --from=build /runtime/ /
COPY --from=build /app/bin/server /app/bin/

# Tell Puppeteer to skip installing Chrome. We'll be using the installed package.
#ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
#    PUPPETEER_SKIP_DOWNLOAD=true \
#    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser \
#    DATA=/app/data

# Puppeteer v19.1.0 works with Chromium 100.
#RUN yarn add 'puppeteer@19.1.0'
#sudo npm install -g puppeteer --unsafe-perm=true -allow-root && sudo apt install chromium-browser -y
#RUN npm init -y && npm i puppeteer

USER root
WORKDIR /app

# Start server.
EXPOSE 8080
CMD ["/app/bin/server"]
