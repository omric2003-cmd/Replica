# Replica

**Replica** turns a dubbing script PDF into translator-ready working files. It detects spoken
dialogue, organizes it into one row per line (one *replica*), lets you review and correct the
parsing, and exports a standard Excel workbook and Word table for translation and dubbing work.

The name comes from the dubbing term for a single spoken line — a *replica* — which is exactly the
unit the app extracts.

---

## What it does

- **Reads a script PDF** entirely in the browser and detects dialogue from uppercase speaker labels.
- **Parses to rows**, one per replica, ignoring scene headers and action description, merging
  wrapped lines, and keeping grouped speakers (e.g. `CHLOE/EMMA`) in a single source cell.
- **Review before export** — edit speaker and dialogue inline, and merge, split, reorder, ignore,
  or delete rows. Ambiguous rows are flagged for a quick human check.
- **Exports**
  - **Excel (.xlsx)** — Sheet 1: `TIMECODE IN · SOURCE · DIALOGUE · TRANSLATION`; Sheet 2:
    character appearance counts (grouped speakers counted individually).
  - **Word (.docx)** — a numbered table with a right-to-left-ready translation column for Hebrew.
- **Accounts and saved projects** (optional) — sign in to save encrypted, resumable projects and
  reopen them from any device.

Translation columns are intentionally left blank in this version. AI-assisted Hebrew drafts with
length-fit indicators for dubbing adaptation are planned for a later release.

---

## Running it

Replica is a single, self-contained HTML file. No build step and no installation.

- **Quickest:** double-click `replica.html` to open it in any modern browser. It runs in
  **local mode** — upload, parse, review, and export all work; only accounts and saving are off.
- **Hosted:** because the file is fully static, you can publish it on any static host
  (GitHub Pages, Netlify, Vercel, Cloudflare Pages) to use it across devices.

An internet connection is needed on first load, since the PDF, Excel, and Word libraries are
fetched from a CDN.

---

## Accounts and saved projects (optional)

Accounts run on [Supabase](https://supabase.com) (free tier is sufficient). To enable them:

1. Create a Supabase project.
2. In **SQL Editor**, run `supabase-schema.sql` to create the `projects` table and its
   row-level-security rules.
3. Copy your **Project URL** and **anon key** from **Project Settings → API**.
4. Paste them into the `CONFIG` block near the top of the `<script>` in `replica.html`.
5. Reload — sign-in and saving are now active.

Full step-by-step instructions are in `SETUP.md`.

### Privacy model

Replica is built so that confidential scripts never sit readable on a server.

- Script text, parsed rows, and the episode name are **end-to-end encrypted in your browser**
  (AES-256-GCM, key derived from your password via PBKDF2) **before** upload.
- The server stores only ciphertext it cannot read. The single unavoidable plaintext is your
  account email, needed for login.
- The encryption key lives in memory only and is never uploaded. On a refresh or a new device you
  re-enter your password to unlock.

**Because encryption is tied to your password, a forgotten password means saved projects cannot be
recovered.** This is the deliberate cost of true end-to-end encryption.

---

## How the parser works

Dialogue detection is rule-based for predictability:

| Rule | Behavior |
|------|----------|
| Scene headers | Lines like `1 EXT. GARDEN - DAY` are ignored. |
| Speaker labels | Standalone uppercase name lines start a new replica. |
| Wrapped dialogue | Following non-speaker lines are joined until the next speaker or a blank line. |
| Description | Prose paragraphs without a speaker label are ignored. |
| Multi-speaker | Grouped names stay in one source cell, but each name is counted separately. |
| Review flags | Empty or unusually long rows are marked *suspicious* for confirmation. |

PDF scripts vary, so the review step exists precisely because no parser is perfect. Always confirm
flagged rows before export.

---

## Project files

| File | Purpose |
|------|---------|
| `replica.html` | The application (single self-contained file). |
| `supabase-schema.sql` | Database table and security rules for accounts. |
| `SETUP.md` | Step-by-step setup for the accounts backend. |
| `dubbing-app-product-spec.md` | The original product specification. |
| `PROJECT-LOG.md` | Version history and change log. |

---

## Tech

Plain HTML, CSS, and JavaScript with no framework. PDF text extraction via **pdf.js**, Excel via
**SheetJS**, Word via **docx**, and encryption via the browser-native **Web Crypto API**. Accounts
and sync use **Supabase** (auth + Postgres with row-level security).

---

## Status

Active development. Current focus is reliable extraction, review, and export. Planned next:
AI-assisted Hebrew translation with dubbing length-fit indicators, speaker aliases, and timecode
import from spotting files.
