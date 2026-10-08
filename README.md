# Dotfiles

Fresh-machine macOS setup: dotfile symlinks, Homebrew packages, and CLI/language
tool versions, all declared in `mise/mise.toml`.

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

Enable **SSH agent** in the Bitwarden desktop app under *Settings → Enable SSH agent*.
`zsh/.zshenv` points SSH tools at Bitwarden's agent socket, and `git/.gitconfig`
uses that agent to sign commits with SSH. SSH host settings are in
`ssh/config`; its `IdentityAgent` setting selects the Bitwarden socket. (This
actually overrides `SSH_AUTH_SOCK` variable.)
Private and public key pairs are stored in Bitwarden. Copies of the public keys
also live in `ssh` as `IdentityFile` selectors, so each host can use its
matching key while the private keys remain in Bitwarden. Unfortunately, Bitwarden
doesn't have a host-based key selector.

### Checking SSH connections

Run the checks for Bitbucket, work GitHub, and personal GitHub:

```bash
ssh -T git@bitbucket.org; ssh -T git@github-work; ssh -T git@github.com
```

## 6. Switch the checkout to SSH

Step 3 cloned over HTTPS because a fresh machine has no SSH keys yet. Now that
the agent is verified (step 5), replace the checkout with an SSH clone so `push`
and `pull` use the agent and no credentials are stored on disk.

```bash
echo "$SSH_AUTH_SOCK"       # must be ~/.bitwarden-ssh-agent.sock, not the system agent
ssh-add -L                 # public keys that agent holds; empty means it is locked
ssh -vT git@github-personal # greets you by username, exit code 1 on success
```

Then clone:

```bash
rm -rf ~/dotfiles && git clone git@github.com:Alputer/dotfiles.git ~/dotfiles
```

Re-link the symlinks into the new checkout (`rm -rf` left them dangling):

```bash
mise bootstrap
```

After this, use `mise bootstrap` — not `--from` — for future runs, since `--from`
requires `origin` to match the requested URL.

## 7. Kanata

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

Keep each app's files directly in its package directory. For example, store
`~/.config/foo/config.toml` as `foo/config.toml`, then add this entry to
`mise/mise.toml`:

```toml
[dotfiles]
"~/.config/foo/config.toml" = { source = "~/dotfiles/foo/config.toml", mode = "symlink" }
```

The key declares the target location, and the source declares the checkout file
that it links to. Apply the link with `mise dot apply`.

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

Once `origin` uses an SSH host alias rather than `github.com` (step 6), use `mise
bootstrap` — not `--from`, which requires the origin to match the requested URL.

## Updating tools and packages

`[tools]` and `[bootstrap.packages]` update through separate commands: mise owns
tool versions and pins them in `mise.lock`, while Homebrew formulae and casks
are re-poured from their current bottles.

```bash
mise lock --bump && mise install --locked           # refresh mise.lock, then commit it
mise bootstrap packages upgrade --manager brew      # formulae
mise bootstrap packages upgrade --manager brew-cask # casks
```

Preview any of the package commands with `--dry-run` first, and append
`--manager` to target one manager. `mise bootstrap packages upgrade` only touches
packages declared in `[bootstrap.packages]`; anything else in the Cellar is left
alone.

To adopt a newer version deliberately, bump it in `mise/mise.toml`
(`mise use <tool>@<version>` does this for you) and commit the refreshed
`mise.lock` alongside it.

Removing a declaration stops mise managing a package but does not uninstall it.
Clean those up with:

```bash
mise bootstrap packages prune --manager brew --dry-run
```
