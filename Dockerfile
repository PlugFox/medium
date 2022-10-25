# docker build . -t plugfox/medium:0.0.1
# docker run -it --rm -w /app -v ${PWD}/data:/app/data -p 8080:8080 plugfox/medium:0.0.1
# docker run -it --rm ubuntu

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
FROM debian:latest as producation

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

# Install latest chrome dev package and fonts to support major charsets (Chinese, Japanese, Arabic, Hebrew, Thai and a few others)
# Note: this installs the necessary libs to make the bundled version of Chromium that Puppeteer
# installs, work.
#RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
#    && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
#    && apt-get update -y \
#    && apt-get install -y google-chrome-unstable fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst \
#    sqlite3 libsqlite3-dev locales --no-install-recommends \
#    && apt-get clean \
#    && rm -rf /var/lib/apt/lists/*

# chromium-browser
RUN apt-get update -y \
    && apt-get install -y --no-install-recommends \
    libssl-dev sqlite3 libsqlite3-dev locales wget gnupg2

RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
    && apt-get update -y \
    && apt-get install -y google-chrome-stable --no-install-recommends \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /app/data

COPY --from=build /runtime/ /
COPY --from=build /app/bin/server /app/bin/

# Tell Puppeteer to skip installing Chrome. We'll be using the installed package.
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_SKIP_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/google-chrome-stable \
    DATA=/app/data

# Puppeteer v19.1.0 works with Chromium 100.
#RUN yarn add 'puppeteer@19.1.0'
#sudo npm install -g puppeteer --unsafe-perm=true -allow-root && sudo apt install chromium-browser -y
#RUN npm init -y && npm i puppeteer

USER root
WORKDIR /app

# Start server.
EXPOSE 8080
CMD ["/app/bin/server"]

#[E] Invalid argument(s): Failed to load dynamic library 'libsqlite3.so': /lib/x86_64-linux-gnu/libc.so.6:
# version `GLIBC_2.33' not found (required by /usr/lib/x86_64-linux-gnu/libsqlite3.so)
