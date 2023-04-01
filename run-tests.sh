#!/usr/bin/env bash

set -euo pipefail

source scripts/utils/log.sh

log_info "Creating docker container to run tests..."
docker build -t kaybinwang/dotfiles.pytest -f Dockerfile.pytest .

log_info "Running tests..."
docker run --rm -t kaybinwang/dotfiles.pytest --name kaybinwang/dotfiles.pytest

log_success "Tests passed!"
