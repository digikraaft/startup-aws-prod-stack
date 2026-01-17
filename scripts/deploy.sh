#!/usr/bin/env bash
set -e
ENV=$1
cd environments/$ENV
tofu init
tofu apply -auto-approve