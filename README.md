# Dotfiles

macOS setup for a fresh machine: Xcode, Homebrew, mise, SSH, GNU Stow, then Kanata.

## Prerequisites

- macOS
- Apple ID (for the App Store)
- Terminal with network access
- A GitHub account with access to this repo

## 1. Install Xcode

Install **Xcode** from the [App Store](https://apps.apple.com/app/xcode/id497799835). This provides the `xcode-select` developer CLI tools Homebrew needs, and is useful for iOS development.

After it finishes installing, accept the license and point `xcode-select` at the app:

```bash
sudo xcodebuild -license accept
sudo xcode-select -s /Applications/Xcode.app/Contents/Developer
```

## 2. Install Homebrew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Add Homebrew to your PATH (Apple Silicon):

```bash
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
```

## 3. Install mise

```bash
brew install mise
```

Activate mise in your current shell (until dotfiles are stowed):

```bash
# zsh
eval "$(mise activate zsh)"

# fish
mise activate fish | source
```

## 4. Set up SSH for GitHub

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

## 5. Clone and enable with Stow

```bash
brew install stow git
git clone git@github.com:Alputer/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

Symlink packages into `$HOME`:

```bash
stow -t ~ aerospace borders fish git kanata mise nvim sketchybar ssh starship wezterm
```

Skip any package you do not want. Do not stow `archive/` (includes retired `karabiner` and `zsh` configs).

If Stow refuses because a file already exists, move or remove the conflict, then re-run the command.

## 6. Install packages and tools

From the repo root:

```bash
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
