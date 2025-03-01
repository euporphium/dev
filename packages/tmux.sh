#!/usr/bin/env bash

if command -v tmux &> /dev/null; then
	echo "✅ tmux is already installed. Skipping."
	exit 0
else
	sudo apt install tmux
fi
