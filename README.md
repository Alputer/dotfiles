# Dotfiles

Fresh-machine macOS setup: dotfile symlinks, Homebrew packages, and CLI/language
tool versions, all declared in `mise/.config/mise.toml`.

The previous Nix/nix-darwin configuration is preserved under `archive/nix/`.

## Prerequisites

- macOS (Apple Silicon)
- Terminal with network access
- A GitHub account (SSH keys are stored in Bitwarden; see step 5)

Homebrew is not required: `mise bootstrap` pours formulae and casks directly.

## 1. Command Line Tools

```bash
xcode-select --install
```

Provides `git` and the compiler tools mise needs. Full Xcode comes in step 4.

## 2. mise

```bash
curl https://mise.run | sh
export PATH="$HOME/.local/bin:$PATH"   # for this shell
```

Installs to `~/.local/bin`, which `zsh/.zshenv` already puts on `PATH`.

## 3. Bootstrap

```bash
mise bootstrap --from https://github.com/Alputer/dotfiles.git --from-dir ~/dotfiles
```

Clones the repo and applies everything: links dotfiles, installs packages and
casks, writes macOS preferences, installs Touch ID for `sudo`, runs the
`bootstrap` task, then installs `[tools]`. Prompts for `sudo` on the system-level
steps.

- `--from-dir` places the checkout at `~/dotfiles`, where `[dotfiles]` expects it.
- Use the HTTPS URL; a fresh machine has no SSH keys yet (step 5).
- Add `--dry-run` to preview, `--yes` to run unattended.
- A real file where a link belongs is refused; use `--force-dotfiles` to replace it.

## 4. Xcode

Installed manually because `mas` is a mise tool, so it is not on `PATH` during
the bootstrap packages phase.

```bash
eval "$(mise activate zsh)"
mas account                   # sign in to the App Store
mas install 497799835         # Xcode
sudo xcodebuild -license accept
```

## 5. SSH with Bitwarden

SSH is **not** tracked here — keys and `~/.ssh/config` stay confidential.
Bitwarden desktop (installed in step 3) is the SSH agent.

In the app: enable **Settings → Enable SSH agent**, then add your keys as **SSH
key** items.

Write `~/.ssh/config` yourself. Point `IdentityFile` at the **public** key and
keep `IdentitiesOnly yes`, so ssh tries only that identity and signs via the
agent. `zsh/.zshenv` exports `SSH_AUTH_SOCK` with a system-agent fallback; to
force Bitwarden always:

```sshconfig
Host *
    IdentityAgent ~/.bitwarden-ssh-agent.sock
```

Verify, then sign commits with the same key:

```bash
ssh-add -L
ssh -T git@github-personal
```

```gitconfig
[gpg]
    format = ssh
[commit]
    gpgsign = true
[user]
    signingkey = ssh-ed25519 AAAA...
```

## 6. Kanata

See [Setting Up Kanata with Karabiner-DriverKit-VirtualHIDDevice on macOS](https://dev.to/the_lazy_/setting-up-kanata-with-karabiner-driverkit-virtualhiddevice-on-macos-1o47).

Restart the daemon after editing `kanata.kbd`, and after any Bluetooth keyboard
connects post-boot (it may miss devices that appear after starting):

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
| `zsh`        | `~/.zshrc`, `~/.zshenv`          |

## Adding a new dotfile

Move the live config into its package directory, then add the entry:

```bash
mv ~/.config/foo/config.toml ~/dotfiles/foo/.config/foo/config.toml
mise dot add -p ~/dotfiles/mise/.config/mise.toml \
  --source ~/dotfiles/foo/.config/foo/config.toml \
  ~/.config/foo/config.toml
```

This writes `"~/.config/foo/config.toml" = "~/dotfiles/foo/.config/foo/config.toml"`
into `[dotfiles]` and links the target. Preview with `--dry-run`.

Both flags are required here:

- `-p` — the config is `mise/.config/mise.toml`, symlinked from
  `~/.config/mise.toml`. Without it mise writes to `~/.config/mise/config.toml`,
  a second file that is not tracked.
- `--source` — without it mise seeds the source at the repo root
  (`~/dotfiles/.config/foo/config.toml`) instead of the package directory that
  every other entry uses.

Check what is linked, or diff pending changes:

```bash
mise dot status
mise dot diff
```

A real file where a link belongs is a conflict — move it aside or pass `--force`.
`archive/` is retired config and is not linked.

### Applying changes

To apply edits you made locally in `~/dotfiles`:

```bash
mise bootstrap
```

That is the whole command. `~/.config/mise.toml` is a symlink into the checkout,
so your edits are already live; bootstrap re-reads the config and brings the
machine in line with it — new links applied, new packages poured, new tools
installed. It is idempotent, so running it on an unchanged config does nothing.

Preview first with `mise bootstrap --dry-run`, or scope it to one phase:
`mise dot apply` for links only, `mise install` for tools only.

Once `origin` uses an SSH host alias rather than `github.com`, use `mise
bootstrap` — not `--from`, which requires the origin to match the requested URL.

## Updating tools and packages

`[tools]` and `[bootstrap.packages]` update through separate commands: mise owns
tool versions and pins them in `mise.lock`, while Homebrew formulae and casks
are re-poured from their current bottles.

```bash
mise upgrade                                       # tools, within declared ranges
mise lock --bump && mise install                   # refresh mise.lock, then commit it
mise bootstrap packages upgrade --manager brew      # formulae
mise bootstrap packages upgrade --manager brew-cask # casks
```

Preview any of the package commands with `--dry-run` first, and append
`--manager` to target one manager. `mise bootstrap packages upgrade` only touches
packages declared in `[bootstrap.packages]`; anything else in the Cellar is left
alone.

To adopt a newer version deliberately, bump it in `mise/.config/mise.toml`
(`mise use <tool>@<version>` does this for you) and commit the refreshed
`mise.lock` alongside it.

Removing a declaration stops mise managing a package but does not uninstall it.
Clean those up with:

```bash
mise bootstrap packages prune --manager brew --dry-run
```
