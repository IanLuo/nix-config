<!-- synced: 3d1c640 -->

# CURSOR — Nix dotfiles (2025-07-28)

**Position:** dev task verified: herdr prefix changed from Ctrl+B to Ctrl+A. Next: continue from the latest evidence.

**Blockers:** none.

**Open:** none.

**Health:** 🟢 verified by fresh evidence.

**Verification:** claimed: prefix changed to ctrl+a; verified: config.toml has `prefix = "ctrl+a"`; `herdr config check` → ok; `herdr server reload-config` → status=applied (fresh @ 3d1c640).

**Errors-that-changed-plan:** none.

**Decisions:** herdr prefix is now Ctrl+A for one-handed use.

**Active pointers:** `docs/prd/herdr-prefix.md` (locked PRD), `~/.config/herdr/config.toml` (config file)
