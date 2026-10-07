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

Clones the repo and applies everything: links dotfiles (including `~/.ssh/config`
and `~/.ssh/known_hosts`), installs packages and casks, writes macOS preferences,
installs Touch ID for `sudo`, runs the `bootstrap` task, then installs `[tools]`.
Prompts for `sudo` on the system-level steps.

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

Nothing to run here: `ssh/.ssh/config` and `ssh/.ssh/known_hosts` are tracked and
symlinked into `~/.ssh` by the dotfiles phase of `mise bootstrap` (step 3). Only
the private keys stay out of the repo — those live in Bitwarden. Edit the files
in the checkout; the symlinks point at the working tree, so changes are live
without any further command.

The rest of this step is activating the Bitwarden agent.

### 5.1 Activate the Bitwarden SSH agent

The keys are already in the vault as **SSH key** items, and the desktop app is
already installed by step 3 as a Homebrew cask. That cask is the `.dmg` build,
which is what the agent needs; the App Store build sandboxes the socket into its
container directory and `~/.bitwarden-ssh-agent.sock` never appears.

Activating the agent therefore means turning it on and pointing `ssh`, `git`,
and everything else at the socket the app exposes.

1. **Turn the agent on:** *Settings → Enable SSH agent*. Set **Ask for
   authorization when using SSH agent** to whatever prompt cadence you want
   (every use, once per hour, or never). The agent is bound to your vault, so
   signing while the vault is locked fails.

2. **Point `ssh` at the agent.** `zsh/.zshenv` already exports
   `SSH_AUTH_SOCK=$HOME/.bitwarden-ssh-agent.sock`, falling back to the system
   agent when that socket is absent. Open a new shell (or re-source) so the
   export runs after the app has created the socket.

3. **Confirm the vault keys are exposed:**

   ```bash
   ssh-add -L                 # should print the public keys of your SSH key items
   ssh -T git@github.com      # should greet you by username
   ```

   Every key you intend to use must be an **SSH key** vault item — keys stored
   as files or attachments are invisible to the agent, and the agent cannot
   read them either. `The agent has no identities` means the vault is locked or
   no SSH key items exist; `communication with agent failed` means
   `SSH_AUTH_SOCK` points at the wrong path, usually an App Store build.

   To add or import a key later: *New → SSH key*, generate an Ed25519 key
   in-app or paste an existing one with **Import key from clipboard**. Imports
   must be OpenSSH or PKCS#8; PuTTYgen keys are not supported.

4. **Make the agent authoritative.** `ssh/.ssh/config` currently points
   `IdentityFile` at private key files that still exist on disk, so `ssh` reads
   those files and never consults the agent. Switch each `IdentityFile` to the
   matching `.pub` and add `IdentityAgent`, then the private files can be
   deleted:

   ```bash
   rm ~/.ssh/id_ed25519_work ~/.ssh/id_ed25519_personal
   ```

   Only remove a file once `ssh-add -L` shows its public half, otherwise the
   host becomes unloggable-into.

### 5.2 Host configuration

`ssh` only asks the agent for a key named by an `IdentityFile`, and
`IdentitiesOnly yes` is what stops it from offering every key the agent holds.
Point `IdentityFile` at the **public** half and Bitwarden answers the request
from the vault; point it at a private key file and `ssh` reads that file
instead. `AddKeysToAgent` is unnecessary and unsupported — Bitwarden implements
only list and sign.

```sshconfig
Host *
    IdentityAgent ~/.bitwarden-ssh-agent.sock
    IdentitiesOnly yes

Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519_work.pub

Host github-personal
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519_personal.pub
```

Edit `ssh/.ssh/config` in the checkout, not `~/.ssh/config`.

### 5.3 Sign commits with the same key

```bash
git config --global gpg.format ssh
git config --global commit.gpgsign true
git config --global user.signingkey "$(ssh-add -L | grep personal | head -1)"
```

`user.signingkey` must be a full `ssh-ed25519 AAAA...` line. Git asks the agent
to sign, so the vault must be unlocked and the app running when you commit.

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
| `ssh`        | `~/.ssh/config`, `~/.ssh/known_hosts` |
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
