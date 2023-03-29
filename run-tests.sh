#!/usr/bin/env bash

for script in $(find tests -name '*.exp'); do
  expect "$script"
done
