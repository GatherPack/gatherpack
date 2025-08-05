source "https://rubygems.org"

# Use main development branch of Rails
gem "rails", "~> 8.0"
# The modern asset pipeline for Rails [https://github.com/rails/propshaft]
gem "propshaft"
# Use postgresql as the database for Active Record
gem "pg", "~> 1.6"
# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"
# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"
# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"
# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"
# Bundle and process CSS [https://github.com/rails/cssbundling-rails]
gem "cssbundling-rails"
# Use Redis adapter to run Action Cable in production
# gem "redis", ">= 4.0.1"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Use the database-backed adapters for Rails.cache, Active Job, and Action Cable
gem "solid_cache"
gem "solid_queue"
gem "solid_cable"

gem "mission_control-jobs"

# Deploy this application anywhere as a Docker container [https://kamal-deploy.org]
gem "kamal", require: false

# Add HTTP asset caching/compression and X-Sendfile acceleration to Puma [https://github.com/basecamp/thruster/]
gem "thruster", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
gem "image_processing", "~> 1.2"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"

  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem "brakeman", require: false

  # Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
  gem "rubocop", require: false
  gem "rubocop-rails-omakase", require: false
  gem "erb_lint", require: false

  gem "standard"
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"
end

# to add back in once he gets it updated for rails 8
# gem "solid_errors", github: "fractaledmind/solid_errors", branch: "main"

gem "devise", "~> 4.9"

gem "simple_form", "~> 5.3"

gem "omniauth", "~> 2.1"

gem "omniauth-rails_csrf_protection", "~> 1.0"

gem "ransack", "~> 4.1"

gem "kaminari", "~> 1.2"

gem "color", "~> 2.0"

gem "pundit", "~> 2.3"

gem "gretel", github: "wobschalli/gretel" # change to main gem once it has support for rails 8

gem "money", "~> 6.19"

gem "money-rails", "~> 1.15"

gem "spicy-proton", "~> 2.1"

gem "paper_trail", "~> 16.0"

gem "postmark-rails", "~> 0.22.1"

gem "pstore"

gem "omniauth-google-oauth2", "~> 1.2"

gem "omniauth-discord", "~> 1.2"

gem "omniauth-github", "~> 2.0"

gem "http", "~> 5.2"

gem "pmap", "~> 1.1"

gem "jbuilder", "~> 2.13"

gem "hotwire_combobox", "~> 0.4.0", github: "braddoeswebdev/hotwire_combobox"

gem "stripe", "~> 15.2"

gem "dotenv", "~> 3.1"

gem "pretender", "~> 0.6.0"

gem "neat_ids"
