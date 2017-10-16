#!/bin/bash

echo "Installing Homebrew and binaries..."
. brew.sh

echo "Installing tools from pip..."
. pip.sh

echo "Installing tools from node..."
. npm.sh

echo "Finished!"
