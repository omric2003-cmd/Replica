# Dubbing Prep v2 — setup guide

Version 2 adds user accounts and saved, resumable projects. Accounts and sync run on
[Supabase](https://supabase.com) (free tier is enough). Script content is **end-to-end
encrypted in the browser** before upload, so the server never sees readable text.

You can open `dubbing-prep-v2.html` right now without any of this — it runs in **local mode**
(everything works except sign-in and saving). To turn on accounts, do the five steps below.

## 1. Create a Supabase project
1. Sign up at supabase.com and create a new project (pick any name and a database password).
2. Wait for it to finish provisioning (about a minute).

## 2. Create the database table
1. In the project, open **SQL Editor → New query**.
2. Paste the entire contents of `supabase-schema.sql` and click **Run**.
   This creates the `projects` table and the row-level-security rules that keep each user's
   data private.

## 3. Get your API keys
1. Open **Project Settings → API**.
2. Copy the **Project URL** and the **anon / public** key.

## 4. Paste the keys into the app
1. Open `dubbing-prep-v2.html` in a text editor.
2. Near the top of the `<script>` block, find the CONFIG section and replace the placeholders:
   ```js
   const SUPABASE_URL = "https://YOURPROJECT.supabase.co";
   const SUPABASE_ANON_KEY = "eyJhbGciOi...your-anon-key...";
   ```
3. Save. Reopen the file in your browser — sign-in is now active.

## 5. (Optional) Email confirmation
By default Supabase emails a confirmation link before a new account can sign in.
- To keep it: after **Create account**, click the link in the email, then sign in.
- To skip it during testing: **Authentication → Providers → Email → turn off "Confirm email"**.

## How it works / good to know
- **Encryption.** On sign-in, a key is derived from your password (PBKDF2, 200k rounds) and an
  AES-256-GCM key is held only in memory. Project data is encrypted before it leaves the browser.
- **Password = the only key.** If a user forgets their password, their saved projects cannot be
  decrypted or recovered. This is the cost of true end-to-end encryption.
- **Refresh / new device.** A returning user is asked to re-enter their password to unlock
  (re-authenticated against Supabase, then the key is re-derived). Nothing sensitive is stored on disk.
- **Hosting.** The file is fully static. To use it across devices, host the single HTML file anywhere
  (Netlify, Vercel, GitHub Pages, Cloudflare Pages) — no server code required.

## What is stored where
| Data | Location | Readable by server? |
|------|----------|---------------------|
| Account email | Supabase Auth | Yes (needed for login) |
| Script text, parsed rows, episode name | `projects.ciphertext` | No — encrypted client-side |
| Encryption key / password | Browser memory only | Never uploaded |
