#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/variants.conf"

possible_paths=(
    "/usr/share/icons"
    "/usr/local/share/icons"
    "/var/usrlocal/share/icons"
    "$HOME/.local/share/icons"
    "$HOME/.icons"
)

MOREWAITADIR=""
ADWAITACOLORSDIR=""

for path in "${possible_paths[@]}"; do
    if [ -d "$path/MoreWaita" ]; then
        MOREWAITADIR="$path/MoreWaita"
        break
    fi
done

for path in "${possible_paths[@]}"; do
    if [ -d "$path/Adwaita-brown" ] || [ -d "$path/Adwaita-pink" ] || [ -d "$path/Adwaita-slate" ]; then
        ADWAITACOLORSDIR="$path"
        break
    fi
done

if [ -z "$MOREWAITADIR" ]; then
    echo "Error: MoreWaita icon theme not found"
    exit 1
fi

if [ -z "$ADWAITACOLORSDIR" ]; then
    echo "Error: Adwaita-colors icon themes not found"
    exit 1
fi

# Files that should be replaced by MoreWaita's versions
# These get moved to mimes/ and replaced with MoreWaita's icons
replace_in_mimetypes=(
    "application-certificate.svg"
    "application-x-addon.svg"
    "application-x-executable.svg"
    "application-x-firmware.svg"
    "application-x-generic.svg"
    "application-x-sharedlib.svg"
    "audio-x-generic.svg"
    "inode-symlink.svg"
    "package-x-generic.svg"
    "text-x-generic.svg"
    "text-x-preview.svg"
    "video-x-generic.svg"
    "x-office-addressbook.svg"
    "x-office-document-template.svg"
    "x-office-drawing.svg"
    "x-office-presentation-template.svg"
    "x-office-spreadsheet.svg"
    "x-office-spreadsheet-template.svg"
    "x-package-repository.svg"
)

for variant in "$ADWAITACOLORSDIR"/Adwaita-*; do
    [ -d "$variant" ] || continue
    variant_name=$(basename "$variant")
    color="${variant_name#Adwaita-}"
    theme_file="$variant/index.theme"
    variant_mimes="$variant/scalable/mimetypes"

    echo "Processing $variant_name..."

    # 1. Patch Inherits chain to MoreWaita first
    if [ -f "$theme_file" ]; then
        sed -i 's/^Inherits=.*/Inherits=MoreWaita,Adwaita,AdwaitaLegacy,hicolor/' "$theme_file"
        echo "  Inherits: MoreWaita,Adwaita,AdwaitaLegacy,hicolor"
    fi

    # 2. Move specified Adwaita SVGs to mimes/ and replace with MoreWaita's
    [ -d "$variant_mimes" ] || continue
    mkdir -p "$variant/scalable/mimes"

    for file in "${replace_in_mimetypes[@]}"; do
        src="$variant_mimes/$file"
        if [ -f "$src" ] && [ ! -f "$variant/scalable/mimes/$file" ]; then
            mv "$src" "$variant/scalable/mimes/"
            echo "  Replaced: $file (moved to mimes)"
        fi
    done

    # 3. Copy all MoreWaita mimetype SVGs into variant (overwrites replaced files)
    if [ -d "$MOREWAITADIR/scalable/mimetypes" ]; then
        for file in "$MOREWAITADIR/scalable/mimetypes"/*; do
            filename=$(basename "$file")
            dest="$variant_mimes/$filename"
            if [ ! -f "$dest" ] && [ ! -L "$dest" ]; then
                cp "$file" "$dest"
                echo "  Added: $filename"
            fi
        done
    fi

    # 4. Recolor new SVGs to match this variant
    mapping="${COLOR_MAP[$color]:-}"
    if [ -n "$mapping" ]; then
        sed_expr=""
        for pair in $mapping; do
            src="${pair%%:*}"
            dst="${pair##*:}"
            [ -n "$sed_expr" ] && sed_expr+="; "
            sed_expr+="s/#${src}/#${dst}/Ig"
        done
        find "$variant_mimes" -name '*.svg' -exec sed -i "$sed_expr" {} +
    fi

    gtk-update-icon-cache -f "$variant" &>/dev/null || true
done

gtk-update-icon-cache -f "$MOREWAITADIR" &>/dev/null || true
echo ""
echo "MoreWaita integration complete!"
