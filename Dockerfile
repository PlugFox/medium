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

RUN dart compile exe bin/server.dart -o bin/server

# Build minimal serving image from AOT-compiled `/server`
# and the pre-built AOT-runtime in the `/runtime/` directory of the base image.
#FROM alpine:3.16.2 as producation
FROM ubuntu:latest as producation

COPY --from=build /runtime/ /
COPY --from=build /app/bin/server /app/bin/

USER root
WORKDIR /app

# Tell Puppeteer to skip installing Chrome. We'll be using the installed package.
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_SKIP_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser \
    DATA=/app/data

# Alpine:
# # Installs latest Chromium (100) package and other dependencies.
# RUN apk add --no-cache \
#     chromium \
#     nss \
#     freetype \
#     harfbuzz \
#     ca-certificates \
#     ttf-freefont \
#     nodejs \
#     yarn \
#     sqlite-libs \
#     sqlite \
#     sqlite-dev
#
# # Add user so we don't need --no-sandbox.
# #RUN addgroup -S user && adduser -S -G user user \
# #    && mkdir -p /home/user/Downloads /app/data \
# #    && chown -R user:user /home/user \
# #    && chown -R user:user /app
# # Run everything after as non-privileged user.
# #USER user

#RUN apt-get update -y \
#    && apt-get install -y wget gnupg \
#    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
#    && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'

RUN apt-get update -y \
    && apt-get install -y --no-install-recommends wget fonts-ipafont-gothic \
    fonts-wqy-zenhei fonts-thai-tlwg fonts-khmeros fonts-kacst \
    fonts-freefont-ttf libxss1 google-chrome-stable  \
    bash curl git ca-certificates zip unzip apt-transport-https \
    sqlite3 libsqlite3-dev locales \
    && apt-get clean

RUN mkdir -p /app/data

# Puppeteer v19.1.0 works with Chromium 100.
#RUN yarn add 'puppeteer@19.1.0'
RUN npm init -y && npm i puppeteer

# Start server.
EXPOSE 8080
CMD ["/app/bin/server"]
