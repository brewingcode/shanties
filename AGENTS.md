# AGENTS.md — shanties

Fuller agent guide for the sea-shanties project. The always-loaded essentials live in `.github/copilot-instructions.md`; read this file for anything beyond a trivial change.

The repo's **primary purpose is the website** (`src/`) — an interactive ABC-notation songbook. The printable saddle-stitch booklet is a secondary artifact derived from the same `songs/`. The site deploys to https://brewingcode.github.io/shanties by `.github/workflows/gh-pages.yml` (Ubuntu, Node 20, `npm install` + `npm run build`).

## Build & run
- `npm run build` — site → `dist/`: runs `./songs-to-json`, then `pug-pack src`, then `cp`s `Songbook.pdf` + `qr-code.svg` into `dist/`. Uses Unix `cp`/`./` (not PowerShell-native).
- Serve locally with live reload: `npx pug-pack src -w` → http://localhost:3000 (browserSync). `npm run dev` watches + rebuilds but does not serve.
- `npm run booklet` / `booklet:proof` / `booklet:single` — lyrics booklet (`booklet/`).
- Syntax-check CoffeeScript snippets by piping (dedented) to `npx coffee -s -c -p`.

## The website (`src/`) — the primary artifact
Interactive ABC songbook: type ABC into `#abc` (or pick a song from the dropdown, or click "add a song" → GitHub `songs/`), and abcjs live-renders staff notation into `#paper`. Settings toggle inline lyrics (`#show-lyrics`), extended verses (`#show-verses`), trumpet fingering (`#show-trumpet`), and guitar tab (`#show-gtab`); `#transpose` shifts the key and shows from/to in `#fromKey`/`#toKey`. Parse warnings render to `#warnings`; on iPad the textarea sits behind an Edit button.
- `src/index.pug` is the whole page (extends pug-pack `_base`). All logic is CoffeeScript in a `:coffeescript` filter; abcjs/jquery/bootstrap are `include`d and inlined into one big `dist/index.html`.
- `songs/*.txt` are ABC songs. `songs-to-json` (a Python script) generates `src/songs.json` (keyed by filename) + `src/by-title.json` (keyed by `T:` title) — both are **generated and gitignored**; run a build if they're missing.
- abcjs renders into `#paper`. UI chrome is tagged `.noprint` (hidden in print and when `body.fullscreen`).
- URL params: `title=` / `file=` pick a song; `fullscreen=true` hides chrome; `lyrics=false`, `verses=false` hide inline / extended lyrics (read before first render).
- `setSong` filters ABC lines pre-render: lowercase `w:` = inline lyrics (or trumpet fingering if all digits), uppercase `W:` = extended verses.
- ABC songs use `%%` directives (e.g. `%%notelabels`, `%%notecolors`, `%%vocalfont`) alongside standard fields (`T:`, `M:`, `K:`, `w:`/`W:`).

## Booklet (markdown-booklet)
- Engine: `node node_modules/markdown-booklet/src/cli.js build booklet/book.yaml [--out … | --reading | --single]`.
- `booklet/` = lyrics (Markdown, two-page spreads).
- Song list source of truth is `booklet/book.yaml`. Not every booklet song has a matching `songs/<slug>.txt` ABC (e.g. `skipper-jan-rebec` was booklet-only for a while).

## Conventions & gotchas
- Prefer Node built-ins over new dependencies.
- `pug-pack` is an **unpinned git-branch** dependency (`brewingcode/pug-pack` in `package.json`) — upstream changes can affect the build.
- Don't write throwaway scripts merely to execute them; validate by reasoning or a one-off inline command. Delete one-shot data-fix scripts after use.
- Don't hard-wrap Markdown to a fixed column width.
- This is a Windows/PowerShell dev box — prefer single-line commands; multi-line array/here-string pastes can mangle in the persistent shell.
- `.playwright-mcp/` is scratch output and is gitignored.
