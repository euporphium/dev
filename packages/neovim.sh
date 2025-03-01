#!/usr/bin/env bash

NEOVIM_VERSION="v0.10.4"
NEOVIM_DIR="$PACKAGE_DIR/neovim"

if command -v nvim &> /dev/null; then
	FOUND_VERSION=$(nvim --version | head -n 1 | awk '{print $2}')

	if [ "$FOUND_VERSION" = "$NEOVIM_VERSION" ]; then
		echo "✅ Neovim $NEOVIM_VERSION is already installed. Skipping."
		exit 0
	else
		echo "🔄 Updating Neovim from $FOUND_VERSION to $NEOVIM_VERSION"
	fi
else
	echo "🆕 Neovim not found. Installing version $NEOVIM_VERSION"
fi

mkdir -p $(dirname "$NEOVIM_DIR")

if [ -d "$NEOVIM_DIR" ]; then
	echo "🗑️  Removing existing Neovim directory"
	rm -rf "$NEOVIM_DIR"
fi

# Install dependencies
echo "📥 Installing build dependencies"
sudo apt-get update
sudo apt-get install -y ninja-build gettext cmake unzip curl build-essential

# Clone the repository
echo "🔄 Cloning Neovim repository..."
git clone -b "$NEOVIM_VERSION" https://github.com/neovim/neovim.git "$NEOVIM_DIR"


cd $HOME/packages/neovim
make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install

# Build and install
echo "🔨 Building Neovim..."
cd "$NEOVIM_DIR"
make CMAKE_BUILD_TYPE=RelWithDebInfo

echo "🔧 Installing Neovim..."
sudo make install

echo "🔍 Verifying installation"
if command -v nvim &> /dev/null; then
    NEW_VERSION=$(nvim --version | head -n 1 | awk '{print $2}')
    echo "✅ Neovim successfully installed: $NEW_VERSION"
else
    echo "❌ Neovim installation failed"
    exit 1
fi

echo "🎉 Neovim installation complete!"
