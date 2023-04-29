# docker build . -t plugfox/medium:0.0.2
# docker run -it --rm -w /app -v ${PWD}/data:/app/data -p 8080:8080 plugfox/medium:0.0.2

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

FROM debian:buster-slim as producation

# Install deps + add Chrome Stable + purge all the things
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends gnupg apt-transport-https libssl-dev \
    sqlite3 libsqlite3-dev locales wget ca-certificates curl lsb-release unzip

# Установите Google Chrome
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'

RUN apt-get update -y && apt-get --fix-broken install \
    && apt-get -y install google-chrome-stable --no-install-recommends

# Tell Puppeteer to skip installing Chrome. We'll be using the installed package.
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_SKIP_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/google-chrome-stable \
    DATA=/app/data

RUN mkdir -p /app/data

#COPY --from=build /app/bin/init /app/bin/
#RUN /app/bin/init
#RUN rm /app/bin/init

# Очистите кэш пакетов
RUN apt-get purge --auto-remove -y gnupg && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY --from=build /app/bin/server /app/bin/

USER root
WORKDIR /app

# Start server.
EXPOSE 8080
CMD ["/app/bin/server"]
