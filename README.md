# Dotfiles

macOS setup for a fresh machine: Bitwarden-backed SSH, Kanata, and dotfile
symlinks.
`bootstrap.sh` symlinks the tracked user settings into `$HOME`; `mise bootstrap`
installs host packages, casks, and App Store apps, applies macOS preferences,
and manages CLI and language tool versions.

The previous Nix/nix-darwin configuration is preserved under `archive/nix/`.

## Prerequisites

- macOS (Apple Silicon)
- Terminal with network access
- A GitHub account (SSH keys are stored in Bitwarden; see step 5)

No Homebrew installation is required: `mise bootstrap` pours Homebrew formulae
and casks directly.

## 1. Install Command Line Tools

```bash
xcode-select --install
```

This provides `git` and the compiler and signing tools that mise and its
Homebrew builds need. Full Xcode is not required yet; `mise bootstrap` installs
Xcode from the App Store (`mas:497799835`) in step 4.

## 2. Install mise

Install mise from its official installer:

```bash
curl https://mise.run | sh
```

This places the `mise` binary in `~/.local/bin`, which `zsh/.zshenv` adds to
`PATH` (and follows with the Homebrew prefix that `mise bootstrap` populates).
Load it in the current shell:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

## 3. Bootstrap dotfiles

One command downloads this repo's tarball to `~/.dotfiles` and symlinks every
tracked package into `$HOME`:

```bash
curl -fsSL https://raw.githubusercontent.com/Alputer/dotfiles/main/bootstrap.sh | bash
```

Re-run it any time to refresh; real files that are in the way are moved aside
to `<file>.bak`. Override the defaults with `DOTFILES_REPO`, `DOTFILES_BRANCH`,
or `DOTFILES_DIR`. See [Adding a new tool](#adding-a-new-tool) for how the
symlinks work.

## 4. Bootstrap the machine

From the repo root (`~/.dotfiles`), preview and apply the declarative setup in
`mise/.config/mise.toml`:

```bash
cd ~/.dotfiles
mise trust
mise bootstrap --dry-run
mise bootstrap
```

`mise bootstrap` installs the host packages, casks, and App Store apps declared
in `[bootstrap.packages]` (including Xcode via `mas`), writes the macOS
preferences in `[bootstrap.macos.*]`, installs Touch ID for `sudo` from
`[bootstrap.files]`, runs the `bootstrap` task, and finally installs the tools
in `[tools]`. It is idempotent, so re-run it after editing `mise.toml`. It
prompts for the `sudo` password for the system-level steps (host name, time
zone, guest login, `/etc/pam.d/sudo_local`).

Xcode installs best-effort: `mas` must be signed in to the App Store, and the
first run may not put `mas` on `PATH` in time. If Xcode is missing, sign in and
run `mise bootstrap packages apply --manager mas` afterwards.

Tools resolve from `mise/.config/mise.toml` and are pinned in
`mise/.config/mise.lock` (linked to `~/.config/mise.lock` by `bootstrap.sh`). To
update a tool within its declared range, run `mise lock --bump` (or
`mise use <tool>@<version>`) and commit the refreshed lockfile. To install only
the pinned tools, `mise install --locked` still works.

Host packages are owned by `[bootstrap.packages]`; removing a declaration stops
managing it. To clean up packages that are no longer declared, preview and then
run `mise bootstrap packages prune --dry-run`.

## 5. Set up SSH with Bitwarden

SSH is deliberately **not** tracked in this repo — keys and `~/.ssh/config` stay
confidential. Bitwarden desktop (installed by `mise bootstrap` in step 4) acts
as the SSH agent, so private keys live only in your vault.

In the Bitwarden desktop app:

1. **Settings → Enable SSH agent** (there is no scriptable switch; this is the
   one manual step).
2. Create or import your SSH keys as **SSH key** items.

Then create `~/.ssh/config` yourself (keep a copy in Bitwarden if you want it
backed up). Because Bitwarden cannot select a key per host, point `IdentityFile`
at the **public** key and keep `IdentitiesOnly yes`, so ssh tries only that
identity and takes the signature from the agent. `zsh/.zshenv` already exports
`SSH_AUTH_SOCK` to the Bitwarden socket, with a fallback to the system agent
when the socket is missing; to force Bitwarden for every host regardless, add:

```sshconfig
Host *
    IdentityAgent ~/.bitwarden-ssh-agent.sock
```

Verify:

```bash
ssh-add -L                  # lists the keys in your vault
ssh -T git@github-personal  # authenticates as the personal account
```

Bitwarden prompts to unlock/authorize on the first signing request.

To sign commits with the same key, add to `git/.gitconfig`:

```gitconfig
[gpg]
    format = ssh
[commit]
    gpgsign = true
[user]
    signingkey = ssh-ed25519 AAAA...
```

## 6. Set up Kanata

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
| `git`        | `~/.gitconfig`                   |
| `kanata`     | `~/.config/kanata`               |
| `mise`       | `~/.config/mise.toml`, `~/.config/mise.lock` |
| `nvim`       | `~/.config/nvim`                 |
| `sketchybar` | `~/.config/sketchybar`           |
| `starship`   | `~/.config/starship.toml`        |
| `wezterm`    | `~/.config/wezterm`              |
| `zsh`        | `~/.zshrc`                       |

## Adding a new tool

Each top-level directory in this repo is a package whose contents mirror
`$HOME`, and `bootstrap.sh` symlinks every file into place:

```text
repo path                            →  linked to
wezterm/.config/wezterm/wezterm.lua  →  ~/.config/wezterm/wezterm.lua
zsh/.zshrc                           →  ~/.zshrc
```

To add a tool, mirror its config path under a package directory, then re-run
`bootstrap.sh` to create the links (existing links are refreshed, and real files
in the way are moved to `<file>.bak`):

```bash
mkdir -p ~/.dotfiles/foo/.config/foo
mv ~/.config/foo/config.toml ~/.dotfiles/foo/.config/foo/
~/.dotfiles/bootstrap.sh
```

`archive/` and `ssh/` are skipped: the former is retired config, the latter
stays confidential outside the repo.

## Git / SSH tips

Your local, untracked `~/.ssh/config` maps `github.com` to the work key and `github-personal` to the personal key. For personal repos (including this one), point the remote at the personal host alias:

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
