#!/bin/bash

# Function to check if directory exists
check_dir() {
    if [ -d "$1" ]; then
        echo "$1"
        return 0
    fi
    return 1
}

# Detect MoreWaita and Adwaita-colors locations
possible_paths=(
    "/var/usrlocal/share/icons"
    "/usr/share/icons"
    "/usr/local/share/icons"
    "$HOME/.local/share/icons"
    "$HOME/.icons"
)

# Initialize variables
MOREWAITADIR=""
ADWAITACOLORSDIR=""

# Find MoreWaita directory
for path in "${possible_paths[@]}"; do
    if [ -d "$path/MoreWaita" ]; then
        MOREWAITADIR="$path/MoreWaita"
        break
    fi
done

# Find Adwaita-colors directory (looking for any of the color variants)
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

# Find actually existing Adwaita variants in the directory
echo "Detecting installed Adwaita variants..."
adwaita_variants=()
for variant in "$ADWAITACOLORSDIR"/Adwaita-*; do
    if [ -d "$variant" ]; then
        variant_name=$(basename "$variant")
        adwaita_variants+=("$variant_name")
        echo "Found: $variant_name"
        
        # Edit index.theme file
        theme_file="$variant/index.theme"
        if [ -f "$theme_file" ]; then
            echo "Updating theme inheritance in $theme_file"
            # Make backup of original file
            cp "$theme_file" "$theme_file.bak"
            
            # Use sed to modify the file in place
            if grep -q "^Inherits=" "$theme_file"; then
                # If Inherits line exists, replace it
                sed -i 's/^Inherits=.*/Inherits=MoreWaita,Adwaita,AdwaitaLegacy,hicolor/' "$theme_file"
            else
                # If Inherits line doesn't exist, add it after [Icon Theme]
                sed -i '/\[Icon Theme\]/a Inherits=MoreWaita,Adwaita' "$theme_file"
            fi
            
            echo "Updated $theme_file"
        else
            echo "Warning: index.theme not found in $variant"
        fi
    fi
done

if [ ${#adwaita_variants[@]} -eq 0 ]; then
    echo "Error: No Adwaita color variants found in $ADWAITACOLORSDIR"
    exit 1
fi

# Process each detected Adwaita color variant
for variant in "${adwaita_variants[@]}"; do
    variant_path="$ADWAITACOLORSDIR/$variant"
    echo "Processing $variant..."
    
    # Create mimes directory if it doesn't exist
    mkdir -p "$variant_path/scalable/mimes"
    
    # Move specified files from mimetypes to mimes
    specified_files=(
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
    
    for file in "${specified_files[@]}"; do
        if [ -f "$variant_path/scalable/mimetypes/$file" ]; then
            mv "$variant_path/scalable/mimetypes/$file" "$variant_path/scalable/mimes/"
            echo "Moved $file to mimes directory"
        fi
    done
    
    # Copy files from MoreWaita mimes to mimetypes, skipping existing files
    if [ -d "$MOREWAITADIR/scalable/mimetypes" ]; then
        for file in "$MOREWAITADIR/scalable/mimetypes"/*; do
            filename=$(basename "$file")
            if [ ! -f "$variant_path/scalable/mimetypes/$filename" ]; then
                cp "$file" "$variant_path/scalable/mimetypes/"
                echo "Copied $filename from MoreWaita to mimetypes"
            fi
        done
    fi
done

# Update icon cache for each variant and MoreWaita
echo "Updating icon caches..."
for variant in "${adwaita_variants[@]}"; do
    variant_path="$ADWAITACOLORSDIR/$variant"
    echo "Updating icon cache for $variant"
    gtk-update-icon-cache -f "$variant_path"
done

echo "Updating MoreWaita icon cache"
gtk-update-icon-cache -f "$MOREWAITADIR"

echo "Processing completed!"
