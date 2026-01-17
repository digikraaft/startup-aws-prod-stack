#!/usr/bin/env bash
set -e
ENV=$1
cd environments/$ENV
tofu destroy -auto-approve