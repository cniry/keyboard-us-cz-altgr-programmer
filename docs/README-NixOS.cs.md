# Instalace na NixOS

Tento repozitář poskytuje Nix balíček i NixOS modul pro XKB rozložení `us-cz-altgr-programmer`.

Anglická verze: [README-NixOS.md](./README-NixOS.md)

## Vzdálené sestavení balíčku

Balíček lze sestavit přímo z GitHubu:

```bash
nix build github:cniry/keyboard-us-cz-altgr-programmer
```

Tím se XKB symbols soubor nainstaluje do výstupu balíčku sem:

```text
share/X11/xkb/symbols/us-cz-altgr-programmer
```

Pro funkční rozložení klávesnice na NixOS je lepší použít NixOS modul. Modul zaregistruje výstup balíčku přes `services.xserver.xkb.extraLayouts`.

## Doporučené použití s flaky

Do systémového `flake.nix` přidejte rozložení klávesnice jako vstup:

```nix
inputs.keyboard-us-cz-altgr-programmer.url = "github:cniry/keyboard-us-cz-altgr-programmer";
```

Potom přidejte exportovaný NixOS modul mezi systémové moduly:

```nix
modules = [
  ./configuration.nix
  inputs.keyboard-us-cz-altgr-programmer.nixosModules.default
];
```

V `configuration.nix` vyberte rozložení:

```nix
services.xserver.xkb = {
  layout = "us-cz-altgr-programmer";
  variant = "";
  options = "lv3:ralt_switch";
};
```

Přestavte systém:

```bash
sudo nixos-rebuild switch --flake /etc/nixos#pavel-omen
```

Potom se odhlaste a znovu přihlaste.

## Kompletní příklad flaku

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

## Použití bez flaku

Naklonujte tento repozitář do:

```text
/etc/nixos/keyboard/keyboard-us-cz-altgr-programmer
```

Příklad:

```bash
sudo mkdir -p /etc/nixos/keyboard
cd /etc/nixos/keyboard
sudo git clone https://github.com/cniry/keyboard-us-cz-altgr-programmer.git keyboard-us-cz-altgr-programmer
```

Potom importujte modul v `/etc/nixos/configuration.nix`:

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

Spusťte:

```bash
sudo nixos-rebuild switch
```

Potom se odhlaste a znovu přihlaste.

## GNOME na Waylandu

GNOME na Waylandu si drží vlastní seznam uživatelských vstupních zdrojů v dconf. Pokud GNOME po restartu stále zobrazuje staré klávesnice, nastavte vstupní zdroj přes Home Manager.

Do uživatelské konfigurace Home Manageru přidejte:

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

Potom systém přestavte a odhlaste se / znovu přihlaste.

## Aktualizace pouze tohoto keyboard flake vstupu

```bash
cd /etc/nixos
sudo nix flake lock --update-input keyboard-us-cz-altgr-programmer
sudo nixos-rebuild switch --flake /etc/nixos#pavel-omen
```

## Self-testy

Z checkoutu tohoto repozitáře:

```bash
nix develop
./tests/run-self-tests.sh
```

Nebo přímo:

```bash
nix flake check
```

## Ověření

Zkontrolujte vstupní zdroje GNOME:

```bash
gsettings get org.gnome.desktop.input-sources sources
gsettings get org.gnome.desktop.input-sources xkb-options
```

Očekávané hodnoty obsahují:

```text
[('xkb', 'us-cz-altgr-programmer')]
['lv3:ralt_switch']
```
