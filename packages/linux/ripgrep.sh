#!/usr/bin/env bash

if command -v ripgrep &> /dev/null; then
	echo "✅ ripgrep is already installed. Skipping."
	exit 0
else
	sudo apt install ripgrep
fi
