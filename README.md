# Adwaita-colors

![showcase](./v2.3.1.jpg)

Adwaita Colors enhances the Adwaita icon theme by integrating GNOME’s accent color feature, introduced in GNOME 47. This project ensures that your Adwaita icons reflect the same accent color as your GNOME theme, instead of the default blue, for a more cohesive and customized look.

GNOME 47 introduced a "color accent" feature to allow users to select a system-wide accent color. However, the default Adwaita icon theme does not automatically adapt to this accent color, leaving the icons in the default blue. Adwaita Colors fixes this by applying your chosen accent color to the icons.

In addition, I added MoreWaita icon folders and made them themed to allow for more extensive customization.

## Installation:

### Requirements:

This theme will not work properly without the original Adwaita icon theme.

### Steps:

Clone the repository to your local machine:

```sh
git clone https://github.com/dpejoh/Adwaita-colors
cd Adwaita-colors
```

To install the icons globally, simply run:

```sh
sudo ./setup -i
```
For removing the icon theme run:
```sh
sudo ./setup -u
```
For immutable distros like Fedora Silverblue, the global installation is different, use:
```sh
./setup -i
```
For removing the icon theme on immutable distros run:
```sh
./setup -u
```
> [!NOTES]

> You can also install the icon theme in the user directory without any problems, but for best compatibility with apps, it is recommended to install it system-wide.

> Adwaita-colors no longer requires separate DEB, RPM, or AUR packages. Thanks to **@fastrizwaan**, the project now includes a unified `setup` script that simplifies both installation and uninstallation across all Linux distributions.

## MoreWaita:

To install MoreWaita with Adwaita-colors:

- Ensure that MoreWaita is installed.
- Run `morewaita.sh` after cloning the repository with the following command:
```sh
./morewaita.sh
```

## Auto Match Adwaita-color with Accent Colors:

To automatically match your accent color with the Adwaita Colors theme, install the official **Adwaita Colors Home** extension.

It watches your GNOME accent color setting and switches the icon theme instantly. It also handles installing and updating Adwaita Colors directly from its preferences UI, so no terminal is needed after the initial setup.

### Installation:

Download the latest release and install it with:

```sh
gnome-extensions install adwaita-colors-home.zip
```

Then log out and back in (Wayland) or press `Alt+F2` and type `r` (X11), then enable it:

```sh
gnome-extensions enable adwaita-colors-home@dpejoh
```

Requires GNOME 47+.