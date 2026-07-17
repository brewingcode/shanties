# Copilot instructions — shanties

**The primary artifact is the website** (`src/`): an interactive ABC-notation songbook — pick or type a song and abcjs live-renders staff notation, with transpose and lyrics / verses / guitar-tab / trumpet-fingering toggles. It deploys to https://brewingcode.github.io/shanties. The two printable **booklets** (`booklet/` = lyrics, `musicbook/` = staff) are secondary artifacts derived from the same `songs/`. **Read `AGENTS.md` for site architecture, URL params/filters, and the booklet/music-capture pipelines before any non-trivial change.**

- Build the site: `npm run build` (Node-only, cross-platform → `dist/`). Serve with live reload: `npx pug-pack src -w` (http://localhost:3000); `npm run dev` rebuilds but does **not** serve.
- `src/songs.json` + `src/by-title.json` are generated & gitignored — run a build if they're missing.
- The Windows build is already fixed via `patches/pug-pack+1.11.0.patch` (applied by `postinstall`/patch-package). Don't re-diagnose or revert it.
- Prefer Node built-ins over new deps; don't leave throwaway scripts; this is a PowerShell box — use single-line commands.
