# AGENTS.md

Rails 8.1 monolith (PostgreSQL, Hotwire, Bootstrap 5, SolidQueue). No Redis.

## Dev setup

```bash
docker compose up -d          # start postgres:16 (localhost:5432, password: password)
bin/setup                     # bundle, yarn, db:migrate (both DBs), clear logs/tmp
bin/dev                       # foreman: web + CSS watcher + SolidQueue worker
```

`bin/dev` uses `Procfile.dev`. Do not run `rails server` alone — the CSS watcher and
background worker will be missing.

## Key commands

```bash
bin/rails test                  # unit/controller/model tests
bin/rails test:system           # Capybara system tests (requires Chrome)
bin/rails test test:system      # both (matches CI)
bin/rails db:test:prepare       # reset test DB — run before tests after schema changes

bin/rubocop -A                  # Ruby linting + auto-fix
erb_lint --lint-all -a          # ERB linting + auto-fix
bin/brakeman --no-pager         # security scan

yarn build:css                  # compile SCSS → autoprefixed CSS (one-shot)
yarn watch:css                  # watch mode (already in Procfile.dev)
```

CI runs 4 parallel jobs: `scan_ruby` (brakeman), `scan_js` (importmap audit),
`lint` (rubocop), `test` (db:test:prepare + test + test:system).

## Dual-database (critical)

Every migration command must be run for **both** databases:

```bash
bin/rails db:migrate:primary    # main app DB
bin/rails db:migrate:versions   # PaperTrail audit log DB (separate PostgreSQL DB)
```

`db:migrate` alone only hits the primary. The versions DB has its own migrations in
`db/versions_migrate/` and its own schema at `db/versions_schema.rb`.

## JavaScript (importmap, no bundler)

No webpack/esbuild. JS is served via `importmap-rails`. To add a package:

```bash
bin/importmap pin some-package   # pins to CDN
```

Large packages (CodeMirror 6, FullCalendar 6) are vendored as ESM files in
`vendor/javascript/`. Do not put JS through a bundler.

Stimulus controllers live in `app/javascript/controllers/`.

## Custom generators

The scaffold generator is customized — it generates the Rails scaffold **plus** a
Pundit policy and a Gretel breadcrumb config:

```bash
bin/rails generate scaffold Foo bar:string   # scaffold + policy + breadcrumb
bin/rails generate policy Foo               # policy only
bin/rails generate breadcrumb Foo           # breadcrumb config only
```

Templates live in `lib/templates/`.

## Settings system

Runtime settings are stored in a PStore file (`storage/settings.pstore`), not in
environment variables or the database. OAuth credentials (Google, Discord, GitHub),
Postmark API key, and feature flags all live here.

Access: `Settings[:key]` anywhere in the app. UI at `/settings`.

The `storage/` directory must be writable. In production it is a mounted persistent
volume.

## Authorization (Pundit)

`app/policies/` has one policy per model. `ApplicationPolicy` defaults **all** actions
to `true` (permissive base). New scaffold-generated policies inherit this and need
explicit restrictions added.

Controller helpers: `admin?`, `architect?`, `manager?`.

## neat_ids

All models use UUID primary keys. The `neat_ids` gem provides human-readable display
IDs with model-specific prefixes (e.g., `usr_…`, `per_…`, `tm_…`).

`ApplicationRecord` has `method_missing` magic for `*_nid=` / `*_nids=` setters that
accept neat IDs and resolve them to UUID foreign keys.


