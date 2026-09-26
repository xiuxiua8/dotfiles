# Herdr Configuration Design

## Goal

Manage Herdr through this dotfiles repository and make its terminal workflow
match the existing tmux configuration where Herdr supports an equivalent.

## Repository Layout

- Store the tracked config at `herdr/.config/herdr/config.toml`.
- Link it to `~/.config/herdr/config.toml` through GNU Stow.
- Add `herdr` to the `PROGRAMS` list in `setup_all.sh` so future setup runs
  deploy it automatically.
- Keep `session.json`, logs, sockets, and other runtime state in
  `~/.config/herdr`; only `config.toml` belongs in the repository.

## Configuration

Use a concise override file instead of copying Herdr's complete generated
default configuration.

- Use the built-in `gruvbox` theme.
- Make new panes, tabs, and workspaces follow the current working directory.
- Use `ctrl+a` as the prefix.
- Use prefix-based pane navigation so Herdr does not intercept control keys
  inside Neovim, shells, or other terminal applications.
- Keep mouse support, pane borders, compact shared pane dividers, and the
  existing space-grouped agent ordering.
- Disable sound and popup notifications to match the quiet tmux settings.

## Keybindings

| Action | Binding |
| --- | --- |
| Reload configuration | `ctrl+a`, then `r` |
| Detach client | `ctrl+a`, then `d` |
| New tab | `ctrl+a`, then `c` |
| Previous/next tab | `ctrl+a`, then `p` / `n` |
| Switch to tab 1-9 | `ctrl+a`, then `1`-`9` |
| Split side by side | `ctrl+a`, then `|` |
| Split stacked | `ctrl+a`, then `-` |
| Focus pane | `ctrl+a`, then `h` / `j` / `k` / `l` |
| Last pane | `ctrl+a`, then `\` |
| Close pane | `ctrl+a`, then `x` |
| Zoom pane | `ctrl+a`, then `z` |
| Enter resize mode | `ctrl+a`, then `shift+r` |

Herdr-specific workspace, navigator, help, settings, and copy-mode bindings
continue to use Herdr's defaults under the new `ctrl+a` prefix.

## Migration

Preserve the current `~/.config/herdr/config.toml` as a timestamped backup,
then use Stow to create the managed file link. Do not stop the Herdr server or
alter the active session. Apply the new config with Herdr's live reload command.

## Verification

1. Confirm `~/.config/herdr/config.toml` resolves to the tracked repository
   file.
2. Dry-run Stow to ensure the `herdr` package is deployable without conflicts.
3. Reload the running Herdr server and confirm the command succeeds.
4. Inspect the server log after reload for invalid keybinding, duplicate
   binding, TOML parsing, or configuration diagnostics.
5. Confirm the active Herdr server remains available after the reload.
