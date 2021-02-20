#!/bin/sh

set -eu

envsubst < /app/initial_config.ini > /app/config.ini
writefreely -c /app/config.ini keys generate
writefreely -c /app/config.ini
