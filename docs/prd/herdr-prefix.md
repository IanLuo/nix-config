<!-- prd:locked:3d1c640 2026-06-27 type=prd -->

## Link contract
- **upstream** (this doc relies on): none
- **referrers** (must cite this when they change): dev-task

# PRD: Change herdr prefix from Ctrl+B to Ctrl+A

## The problem

Ctrl+B is a stretch chord on the keyboard that requires two hands to press, defeating the purpose of a quick prefix key for herdr commands.

## Non-negotiable outcome

After the change, the herdr prefix key is Ctrl+A, usable with one hand (left hand Ctrl + left hand A). A tester can pass/fail by pressing Ctrl+A then `?` and seeing herdr's binding menu with `Ctrl+A` as the listed prefix.

## Scope

### In (V1)
- Change herdr prefix from `ctrl+b` to `ctrl+a` in the herdr config file (`~/.config/herdr/config.toml`)

### Out (deliberately not doing)
- Not changing any other herdr keybindings or functionality
- Not changing how herdr is built, packaged, or deployed in the dotfiles
- Not touching anything else in the repo
- No changes to any other application's keybindings

## Audience & primary flow

**Audience:** Ian (single user).

**Primary flow:**
1. Open herdr in terminal
2. Press Ctrl+A (prefix)
3. Press a command key (e.g., `c` for new tab, `v` for split, `q` for detach)
4. Herdr executes the command

## Acceptance criteria

1. `~/.config/herdr/config.toml` contains `[keys]\nprefix = "ctrl+a"`
2. `herdr config check` passes with no errors
3. After `herdr server reload-config`, pressing Ctrl+A then `?` shows herdr bindings with the new prefix context
4. Ctrl+B no longer triggers herdr prefix mode
5. All existing `prefix+<key>` bindings continue to work (now accessed via Ctrl+A instead of Ctrl+B)
6. No conflict with existing Ctrl+A bindings in Warp or other applications

## Failure modes & non-goals

- **Not promising:** any other herdr configuration changes, performance improvements, or feature additions
- **Success signal:** user can consistently use Ctrl+A one-handed without stretching
- **Failure signal:** the change breaks existing herdr workflows (revert if so)
