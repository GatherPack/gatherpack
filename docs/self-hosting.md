# Self-Hosting GatherPack

GatherPack ships as a single container image that runs the Rails app, plus a
PostgreSQL database. Caching, background jobs, and websockets all live in
PostgreSQL via SolidCache, SolidQueue, and SolidCable.

[`docker-compose.production.yml`](../docker-compose.production.yml) runs three
containers:

| Service  | What it does                                                              |
| -------- | ------------------------------------------------------------------------- |
| `web`    | Puma. Applies migrations on boot, then serves the app on port 3000.        |
| `worker` | `bin/jobs` — SolidQueue background jobs and the `config/recurring.yml` schedule. |
| `db`     | PostgreSQL 16 with a persistent named volume.                             |

Two named volumes hold everything that must survive a redeploy:

- `db_data` — the PostgreSQL data directory.
- `storage` — Active Storage uploads **and** `storage/settings.pstore`, which is
  where runtime settings (Postmark key, OAuth credentials, feature flags) are
  kept. Losing this means reconfiguring the instance from scratch.

## Images

Images are published to the GitHub Container Registry by
[`.github/workflows/build.yml`](../.github/workflows/build.yml) for `linux/amd64`
and `linux/arm64`, and only after the full CI suite passes on that commit:

```
ghcr.io/gatherpack/gatherpack:latest    # newest tagged release
ghcr.io/gatherpack/gatherpack:edge      # newest commit on main
ghcr.io/gatherpack/gatherpack:1.2.3     # a specific release
ghcr.io/gatherpack/gatherpack:sha-abc123
```

Production instances should pin `GATHERPACK_TAG` to a release rather than
tracking `latest`. If you run a fork, set `GATHERPACK_IMAGE` to your own
registry path — the workflow always publishes to the repository it runs in.

## Quick start with Docker Compose

```bash
git clone https://github.com/GatherPack/gatherpack.git
cd gatherpack
cp .env.production.example .env
```

Fill in the four required values in `.env` (`SECRET_KEY_BASE`, `ROOT_URL`,
`DATABASE_PASSWORD`, `JOBS_DASHBOARD_PASSWORD`), generating the secret with:

```bash
openssl rand -hex 64
```

Then:

```bash
docker compose -f docker-compose.production.yml up -d
```

The `web` container creates and migrates the databases on first boot, so it
takes a minute or two before it reports healthy. Watch it with:

```bash
docker compose -f docker-compose.production.yml logs -f web
```

## Reverse proxies and TLS

The `web` container publishes port 3000 on the host (`GATHERPACK_PORT`). Point
your reverse proxy at it, terminate TLS there, and then set **both**:

```
FORCE_SSL=true    # redirect http -> https, mark cookies secure, send HSTS
ASSUME_SSL=true   # trust that the proxy already terminated TLS
```

Setting `FORCE_SSL` without `ASSUME_SSL` produces a redirect loop. Setting
either one while the app is genuinely served over plain HTTP breaks sign-in,
because the session cookie is marked secure and never comes back. Both default
to `false` so a first boot over `http://host:3000` works; turn them on once TLS
is in front.

The health check endpoint `/up` is excluded from both the HTTPS redirect and
`Host` header validation, so container and load balancer probes work without
any extra configuration.

`ROOT_URL` must be the full public URL including the scheme
(`https://gather.example.com`). It drives the hostname allowed by Rails' DNS
rebinding protection and the URLs generated in outgoing email.

## First run

1. Visit `ROOT_URL` and create an account. **The first user to sign up is
   automatically made an admin.** Do this immediately after deploying.
2. Go to `/settings` to configure mail (Postmark API key), OAuth providers,
   and feature flags. These are stored on the `storage` volume, not in
   environment variables.
3. `/setup` links to the rest of the initial configuration, and `/jobs` shows
   the background job dashboard (protected by the HTTP basic auth credentials
   in `JOBS_DASHBOARD_USER` / `JOBS_DASHBOARD_PASSWORD`).

## Using an external PostgreSQL server

Set `DATABASE_HOST`, `DATABASE_USERNAME`, and `DATABASE_PASSWORD` to point at
your server and delete the `db` service (along with the `depends_on` entries
referencing it) from the compose file.

GatherPack uses **three** databases on that server, all created automatically
on boot, so the user needs `CREATEDB`:

- `gatherpack_production` — the application, plus SolidQueue and SolidCache
- `gatherpack_production_versions` — the PaperTrail audit log
- `gatherpack_production_cable` — SolidCable websocket messages

## Backups

Back up the PostgreSQL databases and the `storage` volume together.

```bash
# Databases
docker compose -f docker-compose.production.yml exec db \
  pg_dumpall -U gatherpack > gatherpack-$(date +%F).sql

# Uploads and settings
docker run --rm -v gatherpack_storage:/storage -v "$PWD:/backup" alpine \
  tar czf /backup/gatherpack-storage-$(date +%F).tar.gz -C /storage .
```

`pg_dumpall` is used rather than `pg_dump` because of the three databases
above.

## Operating the stack

```bash
# Rails console
docker compose -f docker-compose.production.yml exec web ./bin/rails console

# Follow logs
docker compose -f docker-compose.production.yml logs -f web worker

# Run migrations by hand (normally automatic on web boot)
docker compose -f docker-compose.production.yml exec web ./bin/rails db:prepare
```

## Tuning

`WEB_CONCURRENCY` sets Puma worker processes (start at the number of CPU
cores) and `RAILS_MAX_THREADS` sets threads per process, which also sizes the
database connection pool. Total connections to PostgreSQL are roughly
`WEB_CONCURRENCY × RAILS_MAX_THREADS` for the web container plus the worker's
own pool, so raise `max_connections` on an external database accordingly.

To run jobs inside the web process instead of a separate container — a smaller
single-container deploy — remove the `worker` service and set
`SOLID_QUEUE_IN_PUMA=true` on `web`.
