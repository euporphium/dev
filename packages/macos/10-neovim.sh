#!/usr/bin/env bash

# Install macOS dependencies
echo "📥 Installing macOS build dependencies for Neovim"
brew install ninja cmake gettext --formula 2>/dev/null
echo "🎉 Neovim dependencies installed successfully on macOS"
