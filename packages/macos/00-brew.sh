#!/usr/bin/env bash

if command -v brew &> /dev/null; then
	echo "✅ Homebrew is already installed. Updating..."
	brew update
	brew upgrade
else
	echo "🔄 Installing Homebrew..."
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

	if [[ $(uname -m) == "arm64" ]]; then
		# For Apple Silicon
		echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.bash_profile
		eval "$(/opt/homebrew/bin/brew shellenv)"
	else
		# For Intel
		echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.bash_profile
		eval "$(/usr/local/bin/brew shellenv)"
	fi
fi

echo "🎉 Homebrew setup complete!"
