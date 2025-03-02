#!/usr/bin/env bash

if command -v zsh &> /dev/null; then
	echo "✅ zsh is already installed. Skipping."
	exit 0
else
	brew install zsh
	sudo chsh -s "$(command -v zsh)"
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi
