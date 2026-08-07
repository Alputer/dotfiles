# Dotfiles

macOS setup for a fresh machine: Xcode, Homebrew, SSH, GNU Stow, then Kanata.

## Prerequisites

- macOS
- Apple ID (for the App Store)
- Terminal with network access
- A GitHub account with access to this repo

## 1. Install Xcode

Install **Xcode** from the [App Store](https://apps.apple.com/app/xcode/id497799835). This provides the `xcode-select` developer CLI tools Homebrew needs, and is useful for iOS development.

## 2. Install Homebrew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## 3. Set up SSH for GitHub

Cloning uses SSH (`git@github.com:...`), so you need a key loaded in `ssh-agent` and added to GitHub.

Generate a key (skip if you already have one, e.g. restored from backup):

```bash
mkdir -p ~/.ssh && chmod 700 ~/.ssh
ssh-keygen -t ed25519 -C "your@email.com" -f ~/.ssh/id_ed25519
```

Start the agent and add the key:

```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```

Copy the public key and add it at [GitHub → SSH keys](https://github.com/settings/keys):

```bash
pbcopy < ~/.ssh/id_ed25519.pub
```

Verify:

```bash
ssh -T git@github.com
```

Your stowed `~/.ssh/config` uses `~/.ssh/id_ed25519` for `github.com`. On macOS the system `ssh-agent` is already available, so no shell startup hook is needed.

## 4. Clone the repo

```bash
git clone git@github.com:Alputer/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

## 5. Stow the dotfiles

```bash
brew install stow
./stow.sh
```

This stows every package directory except `archive/` (retired `karabiner` and `zsh` configs). Edit the `exclude` list in `stow.sh` to skip packages you do not want.

If Stow refuses because a file already exists, move or remove the conflict, then re-run the script.

## 6. Install packages and tools

From the repo root, trust the third-party taps used by the Brewfile, then install:

```bash
brew trust nikitabobko/tap
brew trust felixkratz/formulae
brew bundle
mise install
```

`Brewfile` installs CLI tools, casks, and fonts. `mise install` installs the versions declared in `mise/.config/mise.toml` (already linked to `~/.config/mise.toml` after stowing).

## 7. Set up Kanata

See [Setting Up Kanata with Karabiner-DriverKit-VirtualHIDDevice on macOS](https://dev.to/the_lazy_/setting-up-kanata-with-karabiner-driverkit-virtualhiddevice-on-macos-1o47).

Restart the daemon after editing `~/.config/kanata/kanata.kbd`, and whenever a Bluetooth keyboard connects after boot or wake (Kanata may miss devices that appear after it starts):

```bash
sudo launchctl kickstart -k system/com.kanata.daemon
```

## Packages

| Package     | Links into                       |
|-------------|----------------------------------|
| `aerospace`  | `~/.config/aerospace`            |
| `borders`    | `~/.config/borders`              |
| `fish`       | `~/.config/fish`                 |
| `git`        | `~/.gitconfig`                   |
| `kanata`     | `~/.config/kanata`               |
| `mise`       | `~/.config/mise.toml`            |
| `nvim`       | `~/.config/nvim`                 |
| `sketchybar` | `~/.config/sketchybar`           |
| `ssh`        | `~/.ssh/config`                  |
| `starship`   | `~/.config/starship.toml`        |
| `wezterm`    | `~/.config/wezterm`              |

## Useful Stow commands

```bash
# Restow after edits
stow -t ~ -R <packages...>

# Remove a package's symlinks
stow -t ~ -D <package>
```

## Git / SSH tips

`~/.ssh/config` maps `github.com` to the work key and `github-personal` to the personal key. For personal repos (including this one), point the remote at the personal host alias:

```bash
git remote set-url origin git@github-personal:Alputer/dotfiles.git
```

Verify which account SSH authenticates as:

```bash
ssh -T git@github-personal
```
