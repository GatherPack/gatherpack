# GatherPack

Your one-stop shop for managing a group of people.

## A Little Backstory...

GatherPack's journey began with a FIRST Robotics Competition team drowning in spreadsheets and sticky notes. In those days, critical information about meeting attendance, fundraising progress, and team logistics was scattered across multiple files, desks, and brains. This fragmented system made it challenging for team members to track progress, meet requirements, keep an eye on the finances, or know who was planning on traveling to events without going around and asking people.

[One of the volunteers with the program](https://brad-thompson.com), a web developer by trade, decided to fix this with a simple little web application. This brought all of that operational information together in one place that everyone on the team could access.

And now, almost 10 years later, that organization has basically quadrupled in size & scope - and that original tool is starting to show its age and inability to keep up with some of the ways that the organization runs now. That same volunteer - now the executive director of the organization - and a few of the students on the team decided to build a new tool from the ground up, built to be more flexible, capable, and robust to handle not only their needs, but the needs of other teams and organizations that have been looking for a tool like this to help keep their groups more organized.

## Get Up & Running

On a machine with Ruby & Node & Yarn & Docker installed.

```bash
git clone git@github.com:GatherPack/gatherpack.git
cd gatherpack
bin/setup
docker-compose up
bin/dev
```

## Self-Hosting

`docker-compose.production.yml` runs a full production instance — the app, a
background job worker, and PostgreSQL — from a published container image. No
Redis or other services required.

```bash
cp .env.production.example .env   # then fill in the four required values
docker compose -f docker-compose.production.yml up -d
```

Images are published to `ghcr.io/gatherpack/gatherpack` for amd64 and arm64 on
every release.

See [docs/self-hosting.md](docs/self-hosting.md) for the full guide, including
deploying with [Komodo](https://komo.do), TLS and reverse proxy setup, backups,
and running against an external PostgreSQL server.

## Developer Hints

### Formatting and Linting 

```bash
rubocop -A
erb_lint --lint-all -a
```

### Settings

Settings can be added in the `lib/settings.rb` file in the `initialize` function at the bottom.
Settings follow the format of

```ruby
add_setting(:id, :setting_type, "name", default_value, "group/category", "description")
```

e.g.

```ruby
add_setting(:my_setting, :int, "My Setting", 15, "Very important settings", "Stores an integer")
```
