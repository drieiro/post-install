#!/usr/bin/env bash
#
# Install or update ripgrep debfile.
#

# Check if there is a Internet connection available
if ! ping -c2 example.org &>/dev/null; then
    echo "No internet connection available." && exit 2
fi

[ $UID != 0 ] && echo "Root privileges are necessary." && exit 1
command -v curl &>/dev/null || apt install curl
command -v wget &>/dev/null || apt install wget

name="ripgrep"
tmpfile=$(mktemp)

get_version(){
    command -v rg &>/dev/null && rg --version | head -1 | awk '{print $2}' 2>/dev/null
}

version=$(get_version)

get_new_version(){
    curl -s https://api.github.com/repos/BurntSushi/ripgrep/releases/latest \
    | grep "tag_name" \
    | awk '{print $2}' \
    | tr -d \",
}

new_version=$(get_new_version)

download() {
    curl -s https://api.github.com/repos/BurntSushi/ripgrep/releases/latest \
    | grep "browser_download_url" \
    | grep "amd64.deb\"" \
    | awk '{print $2}' \
    | tr -d \" \
    | xargs wget -nv -O "$tmpfile" \
    && dpkg -i "$tmpfile"
}

if command -v rg &>/dev/null; then
    if [ "$new_version" = "$version" ]; then
        echo "$name is already updated." && notify-send "$name is already updated."
    else
        read -rp "New version available ($new_version). Install? [y/n]: " inst
        ([ "$inst" = 'y' ] && download) || echo "Closing..."
    fi
else
    download
fi
