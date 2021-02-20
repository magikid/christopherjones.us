FROM alpine:3 as base
# WF is only in the testing repo
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
RUN apk --update-cache \
    --no-cache \
    --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community \
    add \
        curl \
        ca-certificates \
        gettext \
        writefreely

WORKDIR /app

# WF requires these in the current directory
RUN mv /usr/share/writefreely/templates .
RUN mv /usr/share/writefreely/static .
RUN mv /usr/share/writefreely/pages .

ARG DB_USERNAME="writefreely"
ARG DB_PASSWORD="admin"
ARG DB_NAME="writefreely"
ARG DB_HOST="localhost"
ARG DB_PORT=3306

# Copy over our config
COPY config.ini initial_config.ini
COPY entrypoint.sh entrypoint.sh
RUN chmod +x entrypoint.sh
CMD ["/app/entrypoint.sh"]

EXPOSE 5000
