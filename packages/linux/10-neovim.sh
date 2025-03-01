#!/usr/bin/env bash

# Install dependencies
echo "📥 Installing build dependencies"
sudo apt-get update >& /dev/null
sudo apt-get install -y ninja-build gettext cmake unzip curl build-essential >& /dev/null

echo "🎉 Neovim dependencies installed successfully on Linux"
