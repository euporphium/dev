#!/usr/bin/env bash

if command -v xclip &> /dev/null; then
	echo "✅ xclip is already installed. Skipping."
	exit 0
else
	sudo apt install xclip
fi

