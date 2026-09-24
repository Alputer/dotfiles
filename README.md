# Dotfiles

macOS setup for a fresh machine. Nix/nix-darwin owns macOS settings and
Homebrew, Home Manager owns user settings, and mise owns CLI and language tool
versions.

## Prerequisites

- macOS
- Apple ID (for the App Store)
- Terminal with network access
- A GitHub account with access to this repo
- Determinate Nix

## 1. Install Xcode

Install **Xcode** from the [App Store](https://apps.apple.com/app/xcode/id497799835). This provides the `xcode-select` developer CLI tools Homebrew needs, and is useful for iOS development.

## 2. Install Determinate Nix

`bootstrap.sh` installs Determinate Nix automatically before the first
activation, so no separate Nix installation is required.

## 3. Set up SSH for GitHub

Cloning uses SSH (`git@github.com:...`), so you need a key loaded in `ssh-agent` and added to GitHub.

Generate the work and personal keys (skip either command if that key already exists, e.g. restored from backup):

```bash
mkdir -p ~/.ssh && chmod 700 ~/.ssh
ssh-keygen -t ed25519 -C "your-work-email@example.com" -f ~/.ssh/id_ed25519_work
ssh-keygen -t ed25519 -C "your-personal-email@example.com" -f ~/.ssh/id_ed25519_personal
```

Start the agent and add the key:

```bash
ssh-add ~/.ssh/id_ed25519_work
ssh-add ~/.ssh/id_ed25519_personal
ssh-add -l
```

Copy each public key and add it to the appropriate work, personal GitHub, or Bitbucket account:

```bash
pbcopy < ~/.ssh/id_ed25519_work.pub
pbcopy < ~/.ssh/id_ed25519_personal.pub
```

The repository's SSH config is installed by Stow after the first activation.

## 4. Clone the repo

```bash
GIT_SSH_COMMAND='ssh -i ~/.ssh/id_ed25519_personal -o IdentitiesOnly=yes' \
  git clone git@github.com:Alputer/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

## 5. Apply the macOS configuration

The bootstrap script installs Determinate Nix if necessary, then performs the
first activation. It installs or migrates Homebrew through nix-homebrew,
declaratively installs the taps, formulae, casks, and Xcode listed in
`nix/homebrew.nix`, and activates Home Manager for `alputer`:

```bash
./bootstrap.sh
```

After the first activation, use:

```bash
sudo darwin-rebuild switch --flake ~/dotfiles#mac
```

The configuration currently targets Apple Silicon and the user `alputer`; update
those values in `nix/*.nix` when using another machine or account. Homebrew
packages not listed in `nix/homebrew.nix` are removed during activation.

## 6. Link dotfiles with Stow

Stow manages the tracked configuration files and directories. From the repo
root, run:

```bash
./stow.sh
```

To restow after edits, run `stow -t ~ -R <packages...>`.

## 7. Install mise tools

From the repo root:

```bash
mise install
```

`mise install` installs the versions declared in `mise/.config/mise.toml`
(linked to `~/.config/mise.toml` by Stow). The repository's
nix-darwin Homebrew module is now the source of truth for Homebrew packages.

## 8. Set up Kanata

See [Setting Up Kanata with Karabiner-DriverKit-VirtualHIDDevice on macOS](https://dev.to/the_lazy_/setting-up-kanata-with-karabiner-driverkit-virtualhiddevice-on-macos-1o47).

Restart the daemon after editing `~/.config/kanata/kanata.kbd`, and whenever a Bluetooth keyboard connects after boot or wake (Kanata may miss devices that appear after it starts):

```bash
sudo launchctl kickstart -k system/com.kanata.daemon
```

## Managed settings

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
| `ssh`        | `~/.ssh/config`, `~/.ssh/known_hosts` |
| `starship`   | `~/.config/starship.toml`        |
| `wezterm`    | `~/.config/wezterm`              |

## Stow commands

Stow manages the tracked configuration files listed above.

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

For work GitHub repositories, use the normal host:

```bash
git remote set-url origin git@github.com:ORG/REPOSITORY.git
```
