# US-CZ AltGr Programmer Keyboard Layout

A US QWERTY keyboard layout for programmers with Czech characters on AltGr.

Czech version: [README.cs.md](./README.cs.md)

Repository:

```text
github.com/cniry/keyboard-us-cz-altgr-programmer
```

Technical names:

```text
XKB layout ID:  us-cz-altgr-programmer
Nix package:    us-cz-altgr-programmer-xkb
Flake input:    keyboard-us-cz-altgr-programmer
```

Version: `0.0.2`

Versioning policy: each project change increments the patch number.
See [CHANGELOG.md](./CHANGELOG.md).

## Goals

- Keep the standard US layout for programming.
- Add Czech characters through AltGr.
- Preserve part of Czech keyboard muscle memory on the number row.
- Avoid Ctrl+AltGr combinations so applications do not treat them as shortcuts.
- Work on NixOS, Ubuntu, Linux Mint, X11, and GNOME/Wayland with the right desktop configuration.
- Be installable remotely from GitHub as a Nix flake package and NixOS module.
- Include self-tests for the layout, package metadata, and XKB syntax.

## Layout

See [layout.md](./layout.md).

Important examples:

```text
AltGr + c = č
AltGr + 4 = č
AltGr + 5 = ř
AltGr + ; = ů
AltGr + \\ = ň
AltGr + Shift + e = €
AltGr + Shift + ` = °
```

## Installation guides

- [NixOS installation](./docs/README-NixOS.md)
- [Ubuntu / Linux Mint installation](./docs/README-Ubuntu-Mint.md)

## Nix flake outputs

This repository exports:

```text
packages.x86_64-linux.default
packages.x86_64-linux.us-cz-altgr-programmer-xkb
packages.aarch64-linux.default
packages.aarch64-linux.us-cz-altgr-programmer-xkb
nixosModules.default
nixosModules.us-cz-altgr-programmer
devShells.x86_64-linux.default
devShells.aarch64-linux.default
checks.*.package
checks.*.self-tests
```

## Remote Nix usage from GitHub

Build the package directly from GitHub:

```bash
nix build github:cniry/keyboard-us-cz-altgr-programmer
```

Install the package into a profile, if you only want the files available in a Nix profile:

```bash
nix profile install github:cniry/keyboard-us-cz-altgr-programmer
```

For actual NixOS keyboard activation, use the exported NixOS module rather than only installing the package.

Show exported flake outputs:

```bash
nix flake show github:cniry/keyboard-us-cz-altgr-programmer
```

Use as a NixOS flake input:

```nix
inputs.keyboard-us-cz-altgr-programmer.url = "github:cniry/keyboard-us-cz-altgr-programmer";
```

Then import the module:

```nix
inputs.keyboard-us-cz-altgr-programmer.nixosModules.default
```

See [NixOS installation](./docs/README-NixOS.md) for a complete example.

## Development shell

With flakes:

```bash
nix develop
```

Without flakes:

```bash
nix-shell
```

The dev shell contains `xkbcomp`, `setxkbmap`, `shellcheck`, `nixfmt`, and common shell tools.

## Self-tests

Run all self-tests in the dev shell:

```bash
./tests/run-self-tests.sh
```

Run flake checks:

```bash
nix flake check
```

The self-tests verify:

- required files exist,
- the renamed project/package/layout names are used consistently,
- stale old project names are absent,
- package and README version is `0.0.2`,
- important key mappings are present,
- the XKB layout compiles with `xkbcomp` when available.

## Quick X11 test

The included test script is only for X11 sessions, not native Wayland apps:

```bash
./scripts/test-local.sh
```

Revert with:

```bash
setxkbmap us
```
