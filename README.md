# Ventua

`app/index.html` is a single-file web app for notes, tasks, a calendar and habits, where every note can live on a day.

- **Today:** the day's note, a schedule you can drag, habit check-offs, and anything due that day.
- **Editing:** type `/` for blocks (headings, to-dos, lists, quotes, dividers) and `@` to link a date or another page.
- **Tasks:** every to-do from every page in one place. A to-do with an `@date` shows up on that day.
- **Calendar:** month view and a year heatmap. **Habits:** streaks and a 14-day grid. **Search:** Ctrl/⌘K over everything.
- **AI (optional):** inside Claude: Plan my day, a weekly review, and `/ai` writing commands. It runs on the viewer's own Claude account and only when they click.
- **Accounts and sync:**
  - **Inside claude.ai:** syncs privately per user through Claude.
  - **On the public website:** free accounts with email and password through Supabase, with live sync across devices.
  - **Without an account:** notes are saved in the browser.

### Go live

1. **Database:** in Supabase, open SQL Editor → New query, paste `supabase/schema.sql`, and click Run.
2. **Hosting:** import this repo on Vercel (or Netlify). `vercel.json` and `netlify.toml` already point them at `app/`, so no settings are needed. Every push to `main` redeploys.
3. **Supabase → Authentication → URL Configuration:** set the Site URL to your live address, and add it to the Redirect URLs.
4. **Emails:** Supabase's built-in email only reaches your own team's addresses. Before the public signs up, either turn off "Confirm email" (Authentication → Providers → Email) or add custom SMTP (for example, Resend's free plan).

`app/vendor/` bundles supabase-js 2.117.3 (MIT). The publishable key in `app/index.html` is public by design, and row-level security in `supabase/schema.sql` keeps each user's data private.
