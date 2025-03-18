#!/usr/bin/env bash

if command -v shfmt &> /dev/null; then
	echo "✅ shfmt is already installed. Skipping."
	exit 0
else
	brew install shfmt
fi
