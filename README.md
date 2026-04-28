# Adwaita-colors

![showcase](./v2.3.1.jpg)

Adwaita Colors enhances the Adwaita icon theme by integrating GNOME's accent color feature, introduced in GNOME 47. This project ensures that your Adwaita icons reflect the same accent color as your GNOME theme, instead of the default blue, for a more cohesive and customized look.

## How It Works

The `setup` script generates icon theme variants (`Adwaita-blue`, `Adwaita-teal`, `Adwaita-brown`, etc.) from your system's installed Adwaita theme. It copies accent-colored SVGs from `/usr/share/icons/Adwaita/scalable/{places,status}`, applies a hex color replacement per variant, then removes any SVGs identical to the originals (they inherit through the chain instead).

**Places and status** — auto-recolored from system Adwaita. Only SVGs that actually change are kept; everything else inherits.

**Apps, folders, mimetypes** — per-variant pre-colored, copied as-is without recolor. Apps and folders are stored in `apps/{variant}/` and `mimetypes/{variant}/`. Custom folder SVGs (`-f` flag) use a single blue source in `folders/` that gets recolored.

Mimetype symlinks for Google Docs, LibreOffice, STL models, and other formats are created automatically in each variant.

## Requirements

- The original Adwaita icon theme installed (ships with GNOME)
- `gtk-update-icon-cache`

## Usage

```sh
git clone https://github.com/dpejoh/Adwaita-colors
cd Adwaita-colors
```

Just run `./setup` with no arguments for an interactive questionnaire:

```
  Adwaita Colors — Setup
  ======================

  What would you like to do?
    1) Install icon themes
    2) Remove icon themes
  (1/2):

  Which color variants?
    1) All 10 variants
    2) Choose specific variants
  (1/2):

  Install location?
    1) System-wide (/usr/share/icons) — may need sudo
    2) Just for my user (~/.local/share/icons)
    3) Custom path

  Include additional custom folder icons? (y/N)

  Summary
  -------
  ...
  Proceed? (Y/n):
```

Or use flags directly:

```sh
sudo ./setup -i                    # Install all variants
sudo ./setup -i teal               # Install just Adwaita-teal
sudo ./setup -i teal brown         # Install specific variants
sudo ./setup -i -P /app            # Install to /app/share/icons
./setup -i                         # Install to user dir (no sudo)
sudo ./setup -i -f                 # Include custom folder icons
sudo ./setup -i -f teal            # Teal with custom folders
sudo ./setup -u                    # Uninstall
```

The script generates variants from system Adwaita, installs them, then cleans up temporary local copies.

> [!NOTE]
> You can install to the user directory (`~/.local/share/icons`) without sudo. System-wide installation is recommended for best app compatibility.

## Custom Folder Icons

Use `-f` or `--folders` to include branded folder icons (GitHub, GitLab, Bitwig, etc.):

```sh
sudo ./setup -i -f
```

These live as a single blue-colored source in `folders/` and get recolored per variant.

## MoreWaita

Ensure [MoreWaita](https://github.com/somepaulo/MoreWaita) is installed, then run:

```sh
sudo ./setup -i -f
./morewaita.sh
```

## Auto Match with Accent Color

Install the official **Adwaita Colors Home** GNOME Shell extension. It watches your accent color and switches the icon theme instantly.

```sh
gnome-extensions install adwaita-colors-home.zip
gnome-extensions enable adwaita-colors-home@dpejoh
```

Requires GNOME 47+.

## Repository Structure

```
Adwaita-colors/
├── setup                 ← Install / uninstall (does everything)
├── variants.conf         ← Color mappings, mimetype symlinks, skip list
├── morewaita.sh          ← MoreWaita integration
├── folders/              ← Single blue source for custom folder SVGs
├── apps/                 ← Per-variant pre-colored app badge SVGs
│   ├── blue/
│   ├── teal/
│   └── ...
├── mimetypes/            ← Per-variant pre-colored mimetype SVGs + symlinks
│   ├── blue/
│   ├── teal/
│   └── ...
├── .gitignore
├── LICENSE
└── README.md
```

No variant directories (`Adwaita-*/`) are shipped — all are generated from system Adwaita during install and cleaned up afterwards.

## License

GPL-3.0
