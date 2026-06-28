# Sea Shanties — booklet

Source for the **Sea Shanties** songbook, built with [markdown-booklet](../../markdown-booklet) into a saddle-stitch, booklet-imposed printable HTML.

## Layout

- Half-letter pages (5.5 × 8.5 in), folded from Letter sheets
- Cover → blank → contents (page 3) → ten songs, each a two-page spread starting on an even page (4, 6, 8, …)
- Titles in **Primitive**; everything else in **Lucida Bright** (with serif fallbacks)

## Build

This folder is the source. The engine lives in the sibling `markdown-booklet` repo:

```sh
source/repos/
  markdown-booklet/   <- the tool (dependency)
  shanties/booklet/   <- this folder
```

From this folder:

```sh
node ../../markdown-booklet/src/cli.js build book.yaml --out sea-shanties.html
```

Reading-order proof (one page per page, no imposition):

```sh
node ../../markdown-booklet/src/cli.js build book.yaml --reading --out proof.html
```

Then open `sea-shanties.html` in a Chromium-based browser and print.

## Print settings

- Paper: Letter, **landscape**
- Margins: None
- Two-sided: on, **flip on long edge**
- Scale: 100%

Fold the stack in half and staple the spine.

## Assets

- `cover.png` — cover illustration (sibling of the output so it resolves)
- `shanties.css` — book styling (wired via `stylesheet:` in `book.yaml`)
- **Primitive** font: drop the file in `fonts/` and uncomment the `@font-face` in `shanties.css`; until then titles fall back to a serif.

## Files

| File | Role |
|---|---|
| `book.yaml` | Manifest: page order, page size, margins, stylesheet |
| `cover.html` | Cover (title + art + byline) |
| `contents.md` | Table of contents + warning + version |
| `*.md` (songs) | One spread per song |
