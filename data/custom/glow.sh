#!/usr/bin/env bash
#
# Install or update glow deb.
#

# Check if there is a Internet connection available
if ! ping -c2 example.org &>/dev/null; then
    echo "No internet connection available." && exit 2
fi

[ $UID != 0 ] && echo "Root privileges are necessary." && exit 1
type curl &>/dev/null || apt install curl
type wget &>/dev/null || apt install wget

name="glow"
tmpfile=$(mktemp)

get_version() {
    echo "v$(glow -v | awk '{print $3}' 2>/dev/null)"
}

version=$(get_version)

get_new_version() {
    curl -s https://api.github.com/repos/charmbracelet/glow/releases/latest \
    | grep "tag_name" \
    | awk '{print $2}' \
    | tr -d \",
}

new_version=$(get_new_version)

download() {
    curl -s https://api.github.com/repos/charmbracelet/glow/releases/latest \
    | grep "browser_download_url" \
    | grep "linux_amd64.deb\"" \
    | awk '{print $2}' \
    | tr -d \" \
    | xargs wget -nv -O "$tmpfile" \
    && dpkg -i "$tmpfile"
}

if command -v glow &>/dev/null; then
    if [ "$new_version" = "$version" ]; then
        echo "$name is already updated." && notify-send "$name is already updated."
    else
        read -rp "New version available ($new_version). Install? [y/n]: " inst
        ([ "$inst" = 'y' ] && download) || echo "Closing..."
    fi
else
    download
fi
