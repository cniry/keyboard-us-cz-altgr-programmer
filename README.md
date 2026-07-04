# US-CZ AltGr Programmer Keyboard Layout

A US QWERTY keyboard layout for programmers with Czech characters on AltGr.

Czech version: [README.cs.md](./README.cs.md)

Technical names:

```text
XKB layout ID:  us-cz-altgr-programmer
```

## Goals

- Keep the standard US layout for programming.
- Add Czech characters through AltGr.
- Preserve part of Czech keyboard muscle memory on the number row.
- Avoid Ctrl+AltGr combinations so applications do not treat them as shortcuts.
- Work on NixOS, Ubuntu, Linux Mint, X11, and GNOME/Wayland with the right desktop configuration.
- Include self-tests for the layout and XKB syntax.

## Layout

See [layout.md](./layout.md).

Important examples:

```text
AltGr + c = č
AltGr + 4 = č
AltGr + 5 = ř
AltGr + ; = ů
AltGr + \\ = ň
AltGr + Shift + e = É
AltGr + ' = €
AltGr + ` = °
```

## Installation guides

- [NixOS installation](./docs/README-NixOS.md)
- [Ubuntu / Linux Mint installation](./docs/README-Ubuntu-Mint.md)

## Self-tests

Run all self-tests:

```bash
./tests/run-self-tests.sh
```

The self-tests verify:

- required files exist,
- the renamed project/package/layout names are used consistently,
- stale old project names are absent,
- package and `VERSION` file version,
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
