# Copilot instructions — shanties

**The primary artifact is the website** (`src/`): an interactive ABC-notation songbook — pick or type a song and abcjs live-renders staff notation, with transpose and lyrics / verses / guitar-tab / trumpet-fingering toggles. It deploys to https://brewingcode.github.io/shanties. The printable **booklet** (`booklet/` = lyrics) is a secondary artifact derived from the same `songs/`. **Read `AGENTS.md` for site architecture, URL params/filters, and the booklet pipeline before any non-trivial change.**

- Build the site: `npm run build` → `dist/`. Serve with live reload: `npx pug-pack src -w` (http://localhost:3000); `npm run dev` rebuilds but does **not** serve.
- `src/songs.json` + `src/by-title.json` are generated & gitignored — run a build if they're missing.
- Prefer Node built-ins over new deps; don't leave throwaway scripts; this is a PowerShell box — use single-line commands.
