#!/usr/bin/env bash

script_dir=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)
filter=""
dry="0"
skip_packages="0"
skip_config="0"

export PACKAGE_DIR="$HOME/packages"

while [[ $# > 0 ]]; do
	if [[ $1 == "--dry" ]]; then
        	dry="1"
	elif [[ $1 == "--skip-packages" ]]; then
        	skip_packages="1"
	elif [[ $1 == "--skip-config" ]]; then
        	skip_config="1"
	else
        	filter="$1"
	fi
	shift
done

log() {
	if [[ $dry == "1" ]]; then
		echo "[DRY_RUN]: $@"
	else
		echo "$@"
	fi
}

execute() {
	log "🔄 Executing: $@"
	if [[ $dry == "1" ]]; then
		return
	fi
	"$@"
}

copy_dir() {
	from=$1
	to=$2

	pushd $from > /dev/null
	dirs=$(find . -mindepth 1 -maxdepth 1 -type d -printf "%f\n")
	for dir in $dirs; do
		execute rm -rf $to/$dir
		execute cp -r $dir $to/$dir
	done
	popd > /dev/null
}

copy_file() {
	from=$1
	to=$2
	name=$(basename $from)

	execute rm $to/$name
	execute cp $from $to/$name
}


echo "🚀 Bootstrap starting from $script_dir with filter: '$filter'"

if [[ "$skip_packages" != "1" ]]; then
	log "📦 Installing Packages"
	pkg_scripts=$(find "$script_dir/packages" -maxdepth 2 -mindepth 1 -type f -executable)
	for pkg_script in $pkg_scripts; do
		if [[ -n "$filter" ]] && echo "$pkg_script" | grep -qv "$filter"; then
			log "🔍 Filtering out: $pkg_script"
			continue
		fi

		execute "$pkg_script"
	done
else
	echo "⏭️  Skipping Packages"
fi

if [[ "$skip_config" != "1" ]]; then
	log "⚙️  Applying Configuration"
	
	: ${XDG_CONFIG_HOME:=$HOME/.config}
	if [[ ! -d "$XDG_CONFIG_HOME" ]]; then
		execute mkdir -p "$XDG_CONFIG_HOME"
	fi

	copy_file config/.zsh_profile $HOME
	copy_file config/.zshrc $HOME
else
	log "⏭️  Skipping Configuration"
fi

log "✅ Bootstrap complete!"
