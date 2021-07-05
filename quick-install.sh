#!/bin/bash

set -euox pipefail

error() {
	echo "==> ERROR: $@"
}

info() {
	echo "==>  INFO: $@"
}

fail() {
	error $@
	exit 1
}

require_command() {
	if ! command -v $1 &>/dev/null; then
		fail "Required command $1 not found"
	fi
}

# check required commands
require_command git
require_command cut
require_command nix-channel
require_command nix-shell

# clone repository

NAME="nixos-configs"

if [ -f "$HOME/.ssh/github_rsa" ]; then
	info "Detected SSH keys, using symlink to Git folder"
	CLONE_BASE="$HOME/Desktop/Git"
	mkdir -p "$CLONE_BASE"
	ln -s "$CLONE_BASE/$NAME" "$HOME/$NAME"
	git clone "git@github.com:anirudhb/$NAME.git" "$CLONE_BASE/$NAME"
else
	info "No SSH keys detected, using normal HTTPS clone"
	CLONE_BASE="$HOME"
	git clone "https://github.com/anirudhb/$NAME.git" "$CLONE_BASE/$NAME"
fi

info "Creating home-manager config symlink..."

ln -s "$HOME/$NAME" "$HOME/.config/nixpkgs"

info "Installing home-manager..."

NIXOS_VERSION="21.05"

if command -v nixos-version &>/dev/null; then
	info "nixos-version not found, assuming Nix version is 21.05"
else
	NIXOS_VERSION="$(nixos-version | cut -d. -f1-2)"
fi

nix-channel --add "https://github.com/nix-community/home-manager/archive/release-$NIXOS_VERSION.tar.gz" home-manager
nix-channel --update

export NIX_PATH="$HOME/.nix-defexpr/channels${NIX_PATH:+:}$NIX_PATH"

nix-shell "<home-manager>" -A install

info "Adding session variables to profile..."

echo '. $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh' >> "$HOME/.profile"

echo "==> Done! You may need to restart your shell for changes to take effect."

