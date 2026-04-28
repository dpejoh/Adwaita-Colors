# Adwaita-colors

![showcase](./v2.3.1.jpg)

Adwaita Colors enhances the Adwaita icon theme by integrating GNOME's accent color feature, introduced in GNOME 47. This project ensures that your Adwaita icons reflect the same accent color as your GNOME theme, instead of the default blue, for a more cohesive and customized look.

GNOME 47 introduced a "color accent" feature to allow users to select a system-wide accent color. However, the default Adwaita icon theme does not automatically adapt to this accent color, leaving the icons in the default blue. Adwaita Colors fixes this by applying your chosen accent color to the icons.

## How It Works

The Adwaita Colors icon variants (`Adwaita-blue`, `Adwaita-teal`, `Adwaita-brown`, etc.) are **generated on demand** from your system's installed Adwaita icon theme. The script copies accent-colored SVG files from `/usr/share/icons/Adwaita`, applies a hex color replacement, then removes any SVGs identical to the originals (they inherit through the theme chain instead).

- Each variant only ships the SVGs that actually change — everything else inherits
- When GNOME updates upstream icons, you pick up changes automatically
- The inherited SVG files aren't duplicated across 10 variants

App badge icons in `apps/` and custom folder icons in `folders/` are single blue-colored source sets that get recolored per variant. Per-variant mimetype icons in `mimetypes/{variant}/` are pre-colored and used as-is, with symlinks created for broader file format coverage.

## Requirements

- The original Adwaita icon theme installed (ships with GNOME)
- `gtk-update-icon-cache` (usually part of `gtk-engines` or `gtk-icon-cache`)

## Installation

Clone the repository:

```sh
git clone https://github.com/dpejoh/Adwaita-colors
cd Adwaita-colors
```

To install the icons globally:

```sh
sudo ./setup -i
```

For removing:

```sh
sudo ./setup -u
```

For immutable distros like Fedora Silverblue:

```sh
./setup -i
./setup -u
```

```sh
sudo ./setup -i                    # Install all variants
sudo ./setup -i teal               # Install just Adwaita-teal
sudo ./setup -i teal brown         # Install specific variants
sudo ./setup -i -P /app            # Install to /app/share/icons
./setup -i                         # Install to user dir (no sudo)
```

To include additional custom folder icons (GitHub, GitLab, Bitwig, etc.), use `-f`:

```sh
sudo ./setup -i -f               # Install all variants with custom folders
sudo ./setup -i -f teal          # Just teal with custom folders
```

> [!NOTE]
> You can also install the icon theme in the user directory without any problems, but for best compatibility with apps, it is recommended to install it system-wide.

## Per-variant Mime Types

Each variant has its own pre-colored mimetype SVGs in `mimetypes/{variant}/`. Place your fixed SVGs there (inode-directory.svg, application-x-addon.svg, oasis-presentation.svg, oasis-web.svg, application-x-model.svg, text-html.svg). The script copies them and creates symlinks for Google Docs, LibreOffice, STL models, and other formats that Adwaita doesn't have icons for.

## MoreWaita

To install MoreWaita with Adwaita-colors:

- Ensure that [MoreWaita](https://github.com/somepaulo/MoreWaita) is installed.
- Run `morewaita.sh` after installing:

```sh
sudo ./setup -i -f
./morewaita.sh
```

## Auto Match Adwaita-color with Accent Colors

To automatically match your accent color with the Adwaita Colors theme, install the official **Adwaita Colors Home** extension.

It watches your GNOME accent color setting and switches the icon theme instantly. It also handles installing and updating Adwaita Colors directly from its preferences UI, so no terminal is needed after the initial setup.

### Installation

Download the latest release and install it with:

```sh
gnome-extensions install adwaita-colors-home.zip
```

Then log out and back in (Wayland) or press `Alt+F2` and type `r` (X11), then enable it:

```sh
gnome-extensions enable adwaita-colors-home@dpejoh
```

Requires GNOME 47+.

## Repository Structure

```
Adwaita-colors/
├── setup                 ← Install / uninstall (does everything)
├── variants.conf         ← Color mappings + mimetype symlinks
├── morewaita.sh          ← MoreWaita integration
├── apps/                 ← Single blue source for app badge SVGs
├── folders/              ← Single blue source for custom folder SVGs
├── mimetypes/            ← Per-variant pre-colored mimetype SVGs
│   ├── blue/
│   ├── teal/
│   └── ...
├── .gitignore
├── LICENSE
└── README.md
```

No variant directories are shipped — all are generated from system Adwaita during install and cleaned up afterwards.

## License

GPL-3.0
