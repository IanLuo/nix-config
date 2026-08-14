<!-- synced: c3d471b -->

# CURSOR.md — state

## Goal
`hm` branch: replace nix-darwin with standalone home-manager + Homebrew.

## Position
Conversion DONE + verified (`nix flake check` passes, both hosts eval). Branch `hm`, commit c3d471b.
Next (user, on this machine): install Homebrew → `./scripts/setup.sh` → verify `which pi claude herdr` → `/opt/homebrew/bin/*`.

## Blockers
None. sudo needed only for optional nix.conf copy (setup.sh handles, non-fatal).

## Open issues
- Homebrew not yet installed on this machine (one curl installer).
- home-manager standalone CLI may not be on PATH → setup.sh falls back to `nix run github:nix-community/home-manager`.
- claude-code cask: verify binary doesn't self-update into ~/.local/share/claude; fix = `CLAUDE_CODE_DISABLE_AUTOUPDATER=1`.
- herdr handoff (live server swap) is lost with brew-managed install — accepted tradeoff.

## Health
🟢 flake check green. User apply + brew install pending.

## Decisions
- Apps → Homebrew (repo-root Brewfile); config → home-manager standalone (no nix-darwin).
- flake-apps machinery deleted (pi-src/herdr inputs, dispatcher, pi.nix, claude-code.nix).
- `flake.homeConfigurations` typed `lazyAttrsOf raw` — `anything` forces full configs (breaks removed home-manager options).
- Aerospace: brew tap cask + home-manager config + home-manager launchd agent.
- Nix daemon settings → `nix.conf` (copied by setup.sh); GC → home-manager launchd agent.

## Active pointers
- `Brewfile` (apps manifest), `modules/hosts/ianluo.nix` (darwin homeConfiguration)
- `scripts/setup.sh`, `nix.conf`, `modules/repo.nix` (homeConfigurations option type)
