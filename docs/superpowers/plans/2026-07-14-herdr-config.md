# Herdr Configuration Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Track a tmux-inspired Herdr configuration in this dotfiles repository and deploy it to the active user account with GNU Stow.

**Architecture:** A focused Stow package owns only `config.toml`, while Herdr continues to own runtime files in `~/.config/herdr`. The setup script deploys the package on future machines, and the current machine migrates through a timestamped backup plus a live server reload.

**Tech Stack:** TOML, Bash, GNU Stow, Herdr 0.7.3

## Global Constraints

- Use `ctrl+a` as the Herdr prefix.
- Pane focus uses prefix-based `h/j/k/l`; do not intercept direct control keys.
- Use Herdr's built-in `gruvbox` theme.
- Keep Herdr runtime state, logs, and sockets outside version control.
- Do not stop the active Herdr server or alter its saved session.
- Preserve the existing `agent_panel_sort = "spaces"` behavior.

---

### Task 1: Add the Herdr Stow Package

**Files:**
- Create: `herdr/.config/herdr/config.toml`
- Modify: `setup_all.sh:11,43-45`

**Interfaces:**
- Consumes: Herdr 0.7.3 configuration fields and the repository's existing `PROGRAMS` Stow loop.
- Produces: A deployable `herdr` Stow package and automatic inclusion in future `setup_all.sh` runs.

- [ ] **Step 1: Verify the package and setup entry are absent**

Run:

```bash
test -f herdr/.config/herdr/config.toml && echo "unexpected config" || echo "missing config"
rg '^PROGRAMS=.*\bherdr\b' setup_all.sh || echo "missing setup entry"
```

Expected output:

```text
missing config
missing setup entry
```

- [ ] **Step 2: Create the concise Herdr configuration**

Create `herdr/.config/herdr/config.toml` with:

```toml
# tmux-inspired Herdr configuration.

[theme]
name = "gruvbox"

[terminal]
new_cwd = "follow"

[keys]
prefix = "ctrl+a"
reload_config = "prefix+r"
detach = "prefix+d"
new_tab = "prefix+c"
previous_tab = "prefix+p"
next_tab = "prefix+n"
switch_tab = "prefix+1..9"
split_vertical = "prefix+|"
split_horizontal = "prefix+minus"
focus_pane_left = "prefix+h"
focus_pane_down = "prefix+j"
focus_pane_up = "prefix+k"
focus_pane_right = "prefix+l"
last_pane = "prefix+backslash"
close_pane = "prefix+x"
zoom = "prefix+z"
resize_mode = "prefix+shift+r"

[ui]
mouse_capture = true
pane_borders = true
pane_gaps = false
agent_panel_sort = "spaces"

[ui.toast]
delivery = "off"

[ui.sound]
enabled = false
```

- [ ] **Step 3: Add Herdr to the Stow program list**

Change the active assignment in `setup_all.sh` to:

```bash
PROGRAMS=(alias aspell bash env git herdr latex python scripts stow tmux vim zsh mac terminal)
```

- [ ] **Step 4: Verify repository content and formatting**

Run:

```bash
test -f herdr/.config/herdr/config.toml
rg '^prefix = "ctrl\+a"$|^split_vertical = "prefix\+\|"$|^agent_panel_sort = "spaces"$' herdr/.config/herdr/config.toml
rg '^PROGRAMS=.*\bherdr\b' setup_all.sh
git diff --check
```

Expected: all commands exit zero; the matching config lines and updated `PROGRAMS` assignment are printed; `git diff --check` prints nothing.

- [ ] **Step 5: Commit the repository configuration**

```bash
git add herdr/.config/herdr/config.toml setup_all.sh
git commit -m "feat: add tmux-inspired Herdr configuration"
```

Expected: one commit containing only the Herdr configuration and setup script change.

- [ ] **Step 6: Remove the pre-existing Bash parse blocker**

The setup script has a Bash shebang but uses the Zsh-only `z*(N)` glob. Replace
that loop header with Bash-compatible glob handling:

```bash
for f in "$HOME"/.zprezto/runcoms/z*; do
    [[ -e "$f" || -L "$f" ]] || continue
```

Run:

```bash
bash -n setup_all.sh
```

Expected: exit zero with no output, proving future setup runs can reach the
Stow loop that now includes Herdr.

### Task 2: Migrate and Reload the Local Configuration

**Files:**
- Backup: `~/.config/herdr/config.toml.bak-<timestamp>`
- Link: `~/.config/herdr/config.toml` -> `/Users/zilong/dotfiles/herdr/.config/herdr/config.toml`

**Interfaces:**
- Consumes: The Stow package created in Task 1 and the running default Herdr server.
- Produces: An active symlinked configuration without changing Herdr session state.

- [ ] **Step 1: Record server state and back up the current config**

Run:

```bash
herdr status server
backup="$HOME/.config/herdr/config.toml.bak-$(date +%Y%m%d%H%M%S)"
mv "$HOME/.config/herdr/config.toml" "$backup"
printf '%s\n' "$backup"
```

Expected: Herdr reports the server status, and the final line prints the backup path.

- [ ] **Step 2: Dry-run and deploy the Stow package**

Run:

```bash
stow --no --verbose --target="$HOME" herdr
stow --verbose --target="$HOME" herdr
```

Expected: the dry run and deployment report creation of `.config/herdr/config.toml` without conflicts.

- [ ] **Step 3: Verify the deployed link**

Run:

```bash
test -L "$HOME/.config/herdr/config.toml"
test "$(readlink "$HOME/.config/herdr/config.toml")" = "../../dotfiles/herdr/.config/herdr/config.toml" \
  || test "$(realpath "$HOME/.config/herdr/config.toml")" = "/Users/zilong/dotfiles/herdr/.config/herdr/config.toml"
```

Expected: both assertions exit zero.

- [ ] **Step 4: Reload Herdr and inspect new diagnostics**

Run:

```bash
log="$HOME/.config/herdr/herdr-server.log"
before=$(wc -l < "$log")
herdr server reload-config
sed -n "$((before + 1)),\$p" "$log" | tee /tmp/herdr-config-reload.log
! rg -i 'invalid keybinding|duplicate binding|config diagnostic|parse error|failed to.*config' /tmp/herdr-config-reload.log
herdr status server
```

Expected: reload succeeds, no invalid-binding or parse diagnostics are found, and the server remains available.

- [ ] **Step 5: Verify runtime files remain unmanaged and the worktree is clean**

Run:

```bash
find herdr -type f -o -type l | sort
git status --short
```

Expected: the Herdr package contains only `.config/herdr/config.toml`, and `git status --short` prints nothing.

If live reload fails, remove the new link, move the timestamped backup back to `~/.config/herdr/config.toml`, run `herdr server reload-config`, and report the diagnostics without stopping the server.
