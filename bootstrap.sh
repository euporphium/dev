#!/usr/bin/env bash

script_dir=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)
filter=""
dry="0"
skip_packages="0"
skip_config="0"

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

# Detect platform
is_macos=0
if [[ "$(uname)" == "Darwin" ]]; then
    is_macos=1
fi

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
	if [[ $is_macos == "1" ]]; then
	    dirs=$(find . -depth 1 -type d | xargs -n 1 basename)
	else
	    dirs=$(find . -mindepth 1 -maxdepth 1 -type d -printf "%f\n")
	fi
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
	
	export PACKAGE_DIR="$HOME/packages"
	if [[ ! -d "$PACKAGE_DIR" ]]; then
	    execute mkdir -p "$PACKAGE_DIR"
	    log "📁 Created package directory: $PACKAGE_DIR"
	fi

	common_pkg_dir="$script_dir/packages/common"
	if [[ $is_macos == "1" ]]; then
	    platform_pkg_dir="$script_dir/packages/macos"
	else
	    platform_pkg_dir="$script_dir/packages/linux"
	fi

	if [[ $is_macos == "1" ]]; then
	        common_scripts=$(find "$common_pkg_dir" -depth 1 -type f -perm +111)
	        platform_scripts=$(find "$platform_pkg_dir" -depth 1 -type f -perm +111)
	else
	        common_scripts=$(find "$common_pkg_dir" -mindepth 1 -maxdepth 1 -type f -executable)
	        platform_scripts=$(find "$platform_pkg_dir" -mindepth 1 -maxdepth 1 -type f -executable)
	fi

	#pkg_scripts=$({ echo "$common_scripts"; echo "$platform_scripts"; } | grep -v "^$" | sort)
	pkg_scripts=$({
		for script in $common_scripts $platform_scripts; do
			echo "$(basename "$script") $script"
		done
	} | sort | awk '{print $2}')
	for pkg_script in $pkg_scripts; do
		if [[ -n "$filter" ]] && echo "$pkg_script" | grep -qv "$filter"; then
			log "🔍 Filtering out: $pkg_script"
			continue
		fi

		execute "$pkg_script"
	done
else
	log "⏭️  Skipping Packages"
fi

if [[ "$skip_config" != "1" ]]; then
	log "⚙️  Applying Configuration"
	
	: ${XDG_CONFIG_HOME:=$HOME/.config}
	if [[ ! -d "$XDG_CONFIG_HOME" ]]; then
		execute mkdir -p "$XDG_CONFIG_HOME"
	fi

	copy_dir config/.config $XDG_CONFIG_HOME
	copy_dir config/.local $HOME/.local

	copy_file config/.zsh_profile $HOME
	copy_file config/.zshrc $HOME
else
	log "⏭️  Skipping Configuration"
fi

log "✅ Bootstrap complete!"
