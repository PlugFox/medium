# docker build . -t medium
# docker run --rm -it -p 8080:8080 medium

# Use latest stable channel SDK.
FROM dart:stable AS build

# Resolve app dependencies.
WORKDIR /app
COPY pubspec.* ./
RUN dart pub get

# Copy app source code (except anything in .dockerignore) and AOT compile app.
COPY . .

RUN dart compile exe bin/server.dart -o bin/server

# Build minimal serving image from AOT-compiled `/server`
# and the pre-built AOT-runtime in the `/runtime/` directory of the base image.
FROM alpine as producation

COPY --from=build /runtime/ /
COPY --from=build /app/bin/server /app/bin/

# Tell Puppeteer to skip installing Chrome. We'll be using the installed package.
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser \
    DATA=/app/data

# Installs latest Chromium (100) package and other dependencies.
RUN mkdir -p /app/data; \
    apk add --no-cache \
    chromium \
    nss \
    freetype \
    harfbuzz \
    ca-certificates \
    ttf-freefont \
    nodejs \
    yarn \
    sqlite

# Puppeteer v19.1.0 works with Chromium 100.
RUN yarn add puppeteer@19.1.0

# Add user so we don't need --no-sandbox.
RUN addgroup -S user && adduser -S -G user user \
    && mkdir -p /home/user/Downloads /app \
    && chown -R user:user /home/user \
    && chown -R user:user /app

# Run everything after as non-privileged user.
USER user

# Start server.
EXPOSE 8080
CMD ["/app/bin/server"]
