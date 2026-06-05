# NixOS installation

This repository provides both a Nix package and a NixOS module for the `us-cz-altgr-programmer` XKB layout.


## Remote package build

The package can be built directly from GitHub:

```bash
nix build github:cniry/keyboard-us-cz-altgr-programmer
```

This installs the XKB symbols file into the package output under:

```text
share/X11/xkb/symbols/us-cz-altgr-programmer
```

For a working NixOS keyboard layout, prefer the NixOS module. The module registers the package output through `services.xserver.xkb.extraLayouts`.

## Recommended usage with flakes

In your system `flake.nix`, add the keyboard layout as an input:

```nix
inputs.keyboard-us-cz-altgr-programmer.url = "github:cniry/keyboard-us-cz-altgr-programmer";
```

Then add the exported NixOS module to your system modules:

```nix
modules = [
  ./configuration.nix
  inputs.keyboard-us-cz-altgr-programmer.nixosModules.default
];
```

In your `configuration.nix`, select the layout:

```nix
services.xserver.xkb = {
  layout = "us-cz-altgr-programmer";
  variant = "";
  options = "lv3:ralt_switch";
};
```

Rebuild:

```bash
sudo nixos-rebuild switch --flake /etc/nixos#pavel-omen
```

Then log out and log back in.

## Complete flake example

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    keyboard-us-cz-altgr-programmer.url = "github:cniry/keyboard-us-cz-altgr-programmer";
  };

  outputs = inputs@{ nixpkgs, home-manager, keyboard-us-cz-altgr-programmer, ... }: {
    nixosConfigurations.pavel-omen = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      specialArgs = {
        inherit inputs;
      };

      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager
        keyboard-us-cz-altgr-programmer.nixosModules.default
      ];
    };
  };
}
```

## Usage without flakes

Clone this repository to:

```text
/etc/nixos/keyboard/keyboard-us-cz-altgr-programmer
```

Example:

```bash
sudo mkdir -p /etc/nixos/keyboard
cd /etc/nixos/keyboard
sudo git clone https://github.com/cniry/keyboard-us-cz-altgr-programmer.git keyboard-us-cz-altgr-programmer
```

Then import the module in `/etc/nixos/configuration.nix`:

```nix
{
  imports = [
    ./hardware-configuration.nix
    ./keyboard/keyboard-us-cz-altgr-programmer/nixos/us-cz-altgr-programmer.nix
  ];

  services.xserver.xkb = {
    layout = "us-cz-altgr-programmer";
    variant = "";
    options = "lv3:ralt_switch";
  };
}
```

Run:

```bash
sudo nixos-rebuild switch
```

Then log out and log back in.

## GNOME on Wayland

GNOME on Wayland keeps its own user input source list in dconf. If GNOME still shows the old keyboards after a reboot, set the input source through Home Manager.

Add this to your Home Manager user config:

```nix
{ pkgs, lib, ... }:

{
  dconf.enable = true;

  dconf.settings = {
    "org/gnome/desktop/input-sources" = {
      sources = [
        (lib.hm.gvariant.mkTuple [ "xkb" "us-cz-altgr-programmer" ])
      ];

      xkb-options = [
        "lv3:ralt_switch"
      ];
    };
  };
}
```

Then rebuild and log out/log back in.

## Updating only this keyboard flake input

```bash
cd /etc/nixos
sudo nix flake lock --update-input keyboard-us-cz-altgr-programmer
sudo nixos-rebuild switch --flake /etc/nixos#pavel-omen
```

## Self-tests

From a checkout of this repository:

```bash
nix develop
./tests/run-self-tests.sh
```

Or directly:

```bash
nix flake check
```

## Verification

Check GNOME input sources:

```bash
gsettings get org.gnome.desktop.input-sources sources
gsettings get org.gnome.desktop.input-sources xkb-options
```

Expected values include:

```text
[('xkb', 'us-cz-altgr-programmer')]
['lv3:ralt_switch']
```
