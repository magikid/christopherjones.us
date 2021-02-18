#!/bin/bash

set -euo pipefail

envsubst < initial_config.ini > config.ini
writefreely -c /app/config.ini keys generate
writefreely -c /app/config.ini
