# AGENTS.md — shanties

Fuller agent guide for the sea-shanties project. The always-loaded essentials live in `.github/copilot-instructions.md`; read this file for anything beyond a trivial change.

The repo's **primary purpose is the website** (`src/`) — an interactive ABC-notation songbook. The two printable saddle-stitch booklets are secondary artifacts derived from the same `songs/`. The site deploys to https://brewingcode.github.io/shanties by `.github/workflows/gh-pages.yml` (Ubuntu, Node 20, `npm install` + `npm run build`).

## Build & run
- `npm run build` — site → `dist/`: runs `songs-to-json.js`, then `pug-pack src`, then copies `Songbook.pdf` + `qr-code.svg`. Cross-platform (Node only — no python/`cp`).
- Serve locally with live reload: `npx pug-pack src -w` → http://localhost:3000 (browserSync). `npm run dev` watches + rebuilds but does not serve.
- `npm run booklet` / `booklet:proof` / `booklet:single` — lyrics booklet (`booklet/`).
- `npm run musicbook` / `musicbook:proof` — staff-notation booklet (`musicbook/`).
- Syntax-check CoffeeScript snippets by piping (dedented) to `npx coffee -s -c -p`.

## The website (`src/`) — the primary artifact
Interactive ABC songbook: type ABC into `#abc` (or pick a song from the dropdown, or click "add a song" → GitHub `songs/`), and abcjs live-renders staff notation into `#paper`. Settings toggle inline lyrics (`#show-lyrics`), extended verses (`#show-verses`), trumpet fingering (`#show-trumpet`), and guitar tab (`#show-gtab`); `#transpose` shifts the key and shows from/to in `#fromKey`/`#toKey`. Parse warnings render to `#warnings`; on iPad the textarea sits behind an Edit button.
- `src/index.pug` is the whole page (extends pug-pack `_base`). All logic is CoffeeScript in a `:coffeescript` filter; abcjs/jquery/bootstrap are `include`d and inlined into one big `dist/index.html`.
- `songs/*.txt` are ABC songs. `songs-to-json.js` generates `src/songs.json` (keyed by filename) + `src/by-title.json` (keyed by `T:` title) — both are **generated and gitignored**; run a build if they're missing.
- abcjs renders into `#paper`. UI chrome is tagged `.noprint` (hidden in print and when `body.fullscreen`).
- URL params: `title=` / `file=` pick a song; `fullscreen=true` hides chrome; `lyrics=false`, `verses=false` hide inline / extended lyrics (read before first render).
- `setSong` filters ABC lines pre-render: lowercase `w:` = inline lyrics (or trumpet fingering if all digits), uppercase `W:` = extended verses.
- ABC songs use `%%` directives (e.g. `%%notelabels`, `%%notecolors`, `%%vocalfont`) alongside standard fields (`T:`, `M:`, `K:`, `w:`/`W:`).

## Booklets (markdown-booklet)
- Engine: `node node_modules/markdown-booklet/src/cli.js build <dir>/book.yaml [--out … | --reading | --single]`.
- `booklet/` = lyrics (Markdown, two-page spreads). `musicbook/` = staff notation (single `type: html` pages, no spreads), parallel to the lyrics book.
- Song list source of truth is `booklet/book.yaml`. Before assuming a song has staff notation, confirm its `songs/<slug>.txt` exists (e.g. `skipper-jan-rebec` was booklet-only for a while).

## Music-book staff capture (`musicbook/pages/*.svg`)
Each staff SVG is captured from the running site. To (re)generate one:
1. Serve the site (`npx pug-pack src -w`).
2. Headlessly load `?file=<slug>.txt&fullscreen=true&verses=false`, grab `#paper svg` outerHTML (strip its inline `style`, set `width=100%`, remove `height`).
3. **Post-process — required, or `<img>` renders broken:** add `xmlns="http://www.w3.org/2000/svg"` to the root `<svg>` (abcjs omits it, so the standalone file is invalid XML) and replace `&nbsp;` → `&#160;` (`&nbsp;` is undefined in standalone XML/SVG). Write UTF-8, no BOM.
The abcjs SVG already renders the `T:` title, so pages need no extra heading; `.staff img` fit-contains within the page (`music.css`). Each `<slug>.html` is just `<div class="staff"><img src="pages/<slug>.svg"></div>`.

## Cross-platform — do not undo
- Windows builds work via **patch-package**: `patches/pug-pack+1.11.0.patch` (applied by the `postinstall` script) fixes pug-pack's Unix-`find` call, its Windows path/regex `srcname` bug, the git `cwd`, and registers a `coffeescript` pug filter (so it no longer depends on hoisting `jstransformer-coffeescript`). Don't revert these or re-diagnose "pug-pack broken on Windows".
- `pug-pack` is an **unpinned git-branch** dependency — if it changes upstream the patch may need refreshing (`npx patch-package pug-pack`).

## Conventions & gotchas
- Prefer Node built-ins over new dependencies (e.g. `fs.cpSync`, not `shx`).
- Don't write throwaway scripts merely to execute them; validate by reasoning or a one-off inline command. Delete one-shot data-fix scripts after use.
- Don't hard-wrap Markdown to a fixed column width.
- This is a Windows/PowerShell dev box — prefer single-line commands; multi-line array/here-string pastes can mangle in the persistent shell.
- `.playwright-mcp/` is scratch output and is gitignored.
