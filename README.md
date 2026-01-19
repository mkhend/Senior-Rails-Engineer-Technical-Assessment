# Campaign Dispatcher (Senior Rails Engineer Technical Assessment)

Proof-of-concept for automating customer feedback collection. It simulates sending review
requests to campaign recipients and shows real-time delivery progress via Turbo Streams.

## Requirements

- Ruby 3.2+
- Rails 7.x
- PostgreSQL
- Redis (for Sidekiq)

## Setup

```bash
bundle install
rails db:create db:migrate
```

If Postgres requires a password, set these environment variables first:

```bash
setx PGUSER postgres
setx PGPASSWORD your_password
setx PGHOST localhost
setx PGPORT 5432
```

### Run the app (web + Tailwind + Sidekiq)

```bash
bin/dev
```

If you prefer, run Sidekiq separately:

```bash
bundle exec sidekiq -C config/sidekiq.yml
```

If `bin/dev` is not available on Windows shells, use:

```bash
foreman start -f Procfile.dev
```

If foreman fails with `Exec format error`, run each process manually:

```bash
bundle exec rails server
bundle exec rails tailwindcss:watch
bundle exec sidekiq -C config/sidekiq.yml
```

### Redis

Ensure Redis is running locally:

```bash
redis-server
```

### Run the test suite

```bash
bundle exec rspec
```

## Architectural decisions

- **Schema:** `Campaign` has many `Recipient` records. Both use string-based enums to keep
  statuses human-readable (`pending/processing/completed`, `queued/sent/failed`).
- **Dispatching:** `DispatchCampaignJob` runs via Sidekiq and simulates delivery with a
  random delay, updating each recipient as `sent`.
- **Real-time updates:** The campaign show page subscribes to a Turbo Stream for the
  campaign. The job broadcasts recipient row replacements and a progress summary frame.
- **UX:** Tailwind is used for a lightweight SaaS-style dashboard without extra JS.

## Future improvements (with 40 hours)

- CSV upload and validation (email/phone normalization, deduping).
- Retry and failure handling (exponential backoff, partial re-dispatch).
- Scheduling + throttling controls (rate limits per campaign).
- Authentication + role-based access for multi-tenant usage.
- Metrics dashboard (conversion rates, average response time).
