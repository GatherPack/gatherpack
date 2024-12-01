source 'https://rubygems.org'

# Use main development branch of Rails
gem 'rails', '~> 8.0'
# The modern asset pipeline for Rails [https://github.com/rails/propshaft]
gem 'propshaft'
# Use sqlite3 as the database for Active Record
gem 'sqlite3', '>= 1.4'
# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '>= 5.0'
# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem 'importmap-rails'
# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem 'turbo-rails'
# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem 'stimulus-rails'
# Bundle and process CSS [https://github.com/rails/cssbundling-rails]
gem 'cssbundling-rails'
# Use Redis adapter to run Action Cable in production
# gem "redis", ">= 4.0.1"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[ windows jruby ]

# Deploy this application anywhere as a Docker container [https://kamal-deploy.org]
gem 'kamal', require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
gem 'image_processing', '~> 1.2'

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[ mri windows ], require: 'debug/prelude'

  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem 'brakeman', require: false

  # Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
  gem 'rubocop-rails-omakase', require: false

  gem 'standard'
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem 'web-console'
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem 'capybara'
  gem 'selenium-webdriver'
end

gem 'activerecord-enhancedsqlite3-adapter', '~> 0.8.0'

gem 'litestream', '~> 0.10.1'

gem 'solid_queue'
gem 'mission_control-jobs', github: 'rails/mission_control-jobs', branch: 'main'

gem 'solid_cache', '~> 0.6.0'

gem 'sqlpkg', '~> 0.2.3'

# to add back in once he gets it updated for rails 8
# gem "solid_errors", github: "fractaledmind/solid_errors", branch: "main"

gem 'devise', '~> 4.9'

gem 'simple_form', '~> 5.3'

gem 'omniauth', '~> 2.1'

gem 'omniauth-rails_csrf_protection', '~> 1.0'

gem 'ransack', '~> 4.1'

gem 'kaminari', '~> 1.2'

gem 'color', '~> 1.8'

gem 'pundit', '~> 2.3'

gem 'gretel', github: 'wobschalli/gretel' # change to main gem once it has support for rails 8

gem "spicy-proton", "~> 2.1"

gem "paper_trail", "~> 16.0"
