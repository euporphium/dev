#!/usr/bin/env bash

if command -v tree &> /dev/null; then
	echo "✅ tree is already installed. Skipping."
	exit 0
else
	sudo apt install tree
fi

