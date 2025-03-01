#!/usr/bin/env bash

if [ ! -d "$PACKAGE_DIR/fzf" ]; then
	git clone --depth 1 https://github.com/junegunn/fzf.git $PACKAGE_DIR/fzf
fi

get_current_version() {
	fzf --version | cut -d' ' -f1
}

get_latest_version() {
	curl -s https://api.github.com/repos/junegunn/fzf/releases/latest | grep -o '"tag_name": *"[^"]*"' | cut -d'"' -f4 | sed 's/^v//'
}

current=$(get_current_version)
latest=$(get_latest_version)

if [ -z "$current" ] || [ "$current" != "$latest" ]; then
	cd $PACKAGE_DIR/fzf
	git pull
	echo n | ./install --completion zsh --key-bindings zsh
else
	echo "✅ fzf is already up to date. Skipping."
fi
