#!/usr/bin/env bash

source scripts/utils/log.sh

log_info "Running all tests..."
for script in $(find tests -name '*.exp'); do
  log_info "Executing expect script: $script"
  expect "$script"
done
