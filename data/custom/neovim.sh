#!/usr/bin/env bash
#
# Install or update Neovim AppImage.
#

# Check if there is a Internet connection available
if ! ping -c2 example.org &>/dev/null; then
    echo "No internet connection available." && exit 2
fi

[ $UID != 0 ] && echo "Root privileges are necessary." && exit 1
type curl &>/dev/null || apt install curl
type wget &>/dev/null || apt install wget

name="Neovim"
location="/usr/bin/nvim"

get_version() {
    command -v nvim &>/dev/null && nvim --version | head -1 | awk '{print $2}' 2>/dev/null
}

version=$(get_version)

get_new_version() {
    curl -s https://api.github.com/repos/neovim/neovim/releases/latest \
    | grep "tag_name" \
    | awk '{print $2}' \
    | tr -d \",
}

new_version=$(get_new_version)

download() {
    curl -s https://api.github.com/repos/neovim/neovim/releases/latest \
    | grep "browser_download_url" \
    | grep ".appimage\"" \
    | awk '{print $2}' \
    | tr -d \" \
    | xargs wget -nv -O $location \
    && chmod +x $location
}

if command -v nvim &>/dev/null; then
    if [ "$new_version" = "$version" ]; then
        echo "$name is already updated." && notify-send "$name is already updated."
    else
        read -rp "New version available ($new_version). Install? [y/n]: " inst
        ([ "$inst" = 'y' ] && download) || echo "Closing..."
    fi
else
    download
fi
