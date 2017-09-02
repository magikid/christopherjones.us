#!/usr/bin/env bash

set -euo pipefail

echo "Beginning deployment"
base_folder=${PWD##*/}

if [ "$base_folder" != "christopherjones.us" ]; then
  echo "Your current directory is $PWD.  This script needs to be called from the christopherjones.us folder."
  exit 1
else
  echo "Transferring files"
  scp site/* website:/home/public
fi

echo "Deployment complete"
