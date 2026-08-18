# AGENTS.md

This is a **configuration repo**, not an application repo. Changes are module wiring, not feature code.

## Portable AI Harness

This repo also maintains a **portable AI harness toolset** — skills, instructions, and CLI tools for AI agents.
These are managed here (single source of truth) and deployed globally to the user's home directory on every
`home-manager switch`, making them available to all AI agents on the machine.

- Source: maintained in this repo
- Deploy target: user home directory (agent-accessible path)
- Activation: triggered by `./scripts/setup.sh` (`home-manager switch` + `brew bundle`)
- Consumers: OpenCode, Claude, Codex, and any agent that scans the deploy path

## Architecture

Every `.nix` file under `modules/` (except hosts and `_`-prefixed paths) is a `flake-parts` module auto-discovered by `import-tree`. No manual import list.

- Shared values live in `config.repo.*` (`modules/repo.nix`). Don't re-thread via `specialArgs`.
- `flake.nix` is an inputs manifest + one-liner. No logic.
- **`_` prefix:** any `.nix` under a `_`-prefixed segment is excluded from auto-import. Use for support files imported explicitly.

## Repository Layout

```
flake.nix
modules/
  repo.nix          checks.nix
  hosts/            ianluo.nix (darwin), ian-linux-dev.nix (linux HM), nixos-vm.nix
  system-packages.nix  home-base.nix  cli.nix  shell.nix  tmux.nix  editor.nix
  system-foundation.nix  window-management.nix
packages/
  custom/           default.nix  stable.nix  unstable.nix  darwin.nix
scripts/
  setup.sh
resources/
  ai/skills/        # Portable AI harness skills (deployed globally on rebuild)
.opencode/skills/    # Project-local skills (this repo only, not deployed)
```

## Commands

- Apply: `./scripts/setup.sh`
- Validate: `nix flake check --all-systems`
- Format: `nix fmt`

## Platform Notes

Darwin can evaluate and build locally. Linux/NixOS targets evaluate on Darwin but full builds need a Linux builder.

## Nix Conventions

- Use `pkgs.stdenv.hostPlatform.system`, not deprecated `pkgs.system`.
- `nixpkgs` is the default source. Use `pkgs.<name>` whenever possible.
- Each tool has **one canonical package symbol** across the repo.
- **Separate package selection from package definition.**
- Custom derivations: `packages/custom/<name>.nix`.
- Host files: declare flake outputs, compose modules. No feature logic.
- Use assertions for invariants that should fail early.

## Shell Script Conventions

- Fail with clear stderr messages. No swallowing errors without deliberate fallback.

## Agent Workflow

1. Read host and module files before editing.
2. Validate the smallest target first (focused `nix eval`), then broader checks.
3. Be honest about platform limitations.
4. **Verify intent before acting.** When a task is ambiguous, unclear, or has unstated assumptions, ask the user to clarify before proceeding.
5. **Ask one question at a time.** Don't dump multiple questions at once — resolve each uncertainty sequentially until the task is fully understood.
6. **Never guess user intent.** If an instruction could be interpreted multiple ways, stop and ask.
7. **Confirm before modifying.** Before changing any file in this repo, confirm your understanding of the task is correct. Don't assume — state what you're about to do and why.

## Deeper docs

| When you need… | Read… | task |
|---|---|---|
| product intent, scope, acceptance criteria for herdr prefix change | `docs/prd/herdr-prefix.md` | 3d1c640 |

---

## State-tracking protocol

Current state is tracked in **`CURSOR.md`** at the repo root. Read it before every
session. It carries forward-looking state git can't express. git history IS the
work-history record. Rewrite `CURSOR.md` in-place at the end of every session.
Never append — append is rot. Hard cap: ≤40 lines / ≤2000 characters.
Every file path in it must exist at write time.

### Inclusion gate — record X iff:
(a) X is NOT recoverable by running one command against an artifact (git/code/CI), AND
(b) a fresh agent would plausibly get WRONG without it.

### Cursor fields

| Field | Content |
|---|---|
| synced | `<!-- synced: <git sha> -->` — staleness oracle (compare to `git rev-parse HEAD`) |
| Goal | stable hex id (12 chars), written once by `create-goal` on a fresh cursor — the Deeper-docs table tags rows to this id |
| Position | current step + next action, merged into one field |
| Blockers | what's stuck + why — to avoid re-hitting the wall |
| Open issues | unresolved questions / assumptions / pending decisions |
| Health | 🟢 green or 🔴 broken + known-broken items |
| Verification | claimed-done vs verified-done, with evidence (test/command @ sha) |
| Errors-that-changed-plan | only failures that redirected the work, not transient retries |
| Decisions | one present-tense line per resolved invariant, not a deliberation timeline |
| Active pointers | file paths → verified to exist at write time |

### Rules
- **Rewrite in-place, never append.** A cursor that only grows is a bug.
- **Pointers over contents.** Where state lives in an artifact, store the *command* or *path*, not the output. Can't drift; costs less.
- **Every path must exist at write time.**
- **Decisions collapse to one present-tense line.** Not a timeline.
