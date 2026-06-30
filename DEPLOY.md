# Deploying Replica as a shared web link

Replica is a static site (just HTML/CSS/JS), so hosting is simple and free. Because your
repository is **private**, GitHub Pages' free tier won't host it — use one of the hosts below,
which all deploy private repos for free. `index.html` redirects to `replica.html`, so the root
URL opens the app directly.

This setup is for the **converter only** (no sign-in). Account controls are hidden automatically
when no Supabase backend is configured, so users just upload, review, and export.

## Option A — Netlify, connected to GitHub (recommended; auto-updates)
1. Go to https://app.netlify.com and sign up (you can sign in with GitHub).
2. **Add new site -> Import an existing project -> Deploy with GitHub.**
3. Authorize Netlify and pick the **Replica** repo.
4. Settings: **Build command** = leave empty; **Publish directory** = `/` (root). Click **Deploy**.
5. You get a URL like `https://replica-xyz.netlify.app`. Share that link.
6. Optional: **Site settings -> Change site name** to make it tidier, e.g. `your-name-replica.netlify.app`.

Every time you push from GitHub Desktop, Netlify redeploys automatically.

## Option B — Netlify Drop (fastest, no Git)
1. Go to https://app.netlify.com/drop
2. Drag the whole `preparing PDF for dubbing` folder onto the page.
3. You instantly get a public URL. (To update later, drag the folder again.)

## Option C — Vercel or Cloudflare Pages
Both work the same way and support private repos free:
- **Vercel:** https://vercel.com -> Add New Project -> import the repo -> Framework preset **Other** ->
  no build command -> Deploy.
- **Cloudflare Pages:** https://dash.cloudflare.com -> Workers & Pages -> Create -> Pages ->
  Connect to Git -> pick the repo -> no build command -> output directory `/` -> Save and Deploy.

## Notes
- The app loads its PDF/Excel/Word libraries from a CDN, so users need an internet connection.
- Anyone with the link can open the converter. The link itself is the only access control in this
  mode; if you later want per-user logins, enable the Supabase backend (see SETUP.md).
- Nothing a user uploads is sent anywhere in converter mode — parsing and export happen entirely
  in their own browser.
