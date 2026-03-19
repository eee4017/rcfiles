# rcfiles

Frank Lin's dotfiles for a Linux desktop with i3wm, zsh, vim, and tmux.

## Quick start

```bash
git clone --recursive <repo-url> ~/rcfiles
cd ~/rcfiles
chmod +x setup.sh
./setup.sh
```

The install script will:

1. Install [oh-my-zsh](https://ohmyz.sh/) and plugins (`zsh-autosuggestions`, `up`)
2. Symlink every config file to its expected location
3. Back up any existing files to `~/.dotfiles_backup/<timestamp>/`
4. Initialize git submodules (i3blocks)

## Repository layout

```
rcfiles/
├── setup.sh                    # install script
├── zsh/
│   ├── zshrc                   # main zsh config (oh-my-zsh, aliases)
│   └── zshrc.sup               # supplementary (URXVT keys, xclip, proxy)
├── vim/
│   └── vimrc                   # vim config (desert, relative numbers, leader ;)
├── tmux/
│   └── tmux.conf               # tmux config (prefix C-a, mouse, vi copy)
├── xorg/
│   ├── xinitrc                 # X startup (fcitx, wal, dunst, i3)
│   └── Xresources              # Xft + URXVT (transparent, monospace + CJK)
├── urxvt/
│   └── Xresources              # alternative URXVT config (opaque, Ubuntu Mono)
├── config/                     # XDG ~/.config/ entries
│   ├── i3/config               # i3wm (gaps, dmenu, screenshots, i3blocks bar)
│   ├── dunst/dunstrc           # notification daemon
│   ├── ranger/                 # file manager
│   ├── fcitx/                  # input method (Chewing / Traditional Chinese)
│   ├── autostart/              # XDG autostart entries
│   ├── libinput-gestures.conf  # touchpad gestures
│   └── mimeapps.list           # default applications
├── jupyter/
│   └── custom/                 # Jupyter Notebook theme & keymap
└── pickle.jpg
```

## What gets linked

| Source                              | Destination                          |
| ----------------------------------- | ------------------------------------ |
| `zsh/zshrc`                         | `~/.zshrc`                           |
| `zsh/zshrc.sup`                     | `~/.zshrc.sup`                       |
| `vim/vimrc`                         | `~/.vimrc`                           |
| `tmux/tmux.conf`                    | `~/.tmux.conf`                       |
| `xorg/xinitrc`                      | `~/.xinitrc`                         |
| `xorg/Xresources`                   | `~/.Xresources`                      |
| `config/i3`                         | `~/.config/i3`                       |
| `config/dunst`                      | `~/.config/dunst`                    |
| `config/ranger`                     | `~/.config/ranger`                   |
| `config/fcitx`                      | `~/.config/fcitx`                    |
| `config/autostart`                  | `~/.config/autostart`                |
| `config/libinput-gestures.conf`     | `~/.config/libinput-gestures.conf`   |
| `config/mimeapps.list`              | `~/.config/mimeapps.list`            |
| `jupyter/custom`                    | `~/.jupyter/custom`                  |

## Dependencies

These are the tools configured by this repo:

- **Shell**: zsh, [oh-my-zsh](https://ohmyz.sh/)
- **Editor**: vim
- **Terminal multiplexer**: tmux
- **Terminal emulator**: URXVT (rxvt-unicode)
- **Window manager**: [i3-gaps](https://github.com/Airblader/i3), [i3blocks](https://github.com/vivien/i3blocks)
- **Notifications**: [dunst](https://dunst-project.org/)
- **File manager**: [ranger](https://github.com/ranger/ranger)
- **Input method**: [fcitx](https://fcitx-im.org/) + Chewing (Traditional Chinese)
- **Touchpad**: [libinput-gestures](https://github.com/bulletmark/libinput-gestures)
- **Screenshots**: [maim](https://github.com/naelstrof/maim)
- **Clipboard**: xclip
- **Theming**: [pywal](https://github.com/dylanaraps/pywal)
- **Notebooks**: Jupyter Notebook

## Notes

- `urxvt/Xresources` is an alternative URXVT config (opaque background, Ubuntu Mono font). To use it, copy it over `xorg/Xresources` or source it manually.
- `zshrc.sup` is sourced automatically from `zshrc` if `~/.zshrc.sup` exists. Put machine-local overrides there.
- The install script is idempotent -- running it again will skip already-correct symlinks.
