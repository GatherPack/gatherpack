require_relative "boot"
ENV["RANSACK_FORM_BUILDER"] = "::SimpleForm::FormBuilder"
require "rails/all"

require_relative "../lib/settings"
require_relative "../lib/gatherpack/feature"
require_relative "../lib/gatherpack/features"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Gatherpack
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.0

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks generators templates middleware gatherpack])

    # required for gatway registry to load properly in workers
    config.rake_eager_load = true

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Set Time.zone default to UTC to keep everything nice and consistent.
    config.time_zone = "UTC"

    config.active_job.queue_adapter = :solid_queue
    config.active_record.yaml_column_permitted_classes = [ Symbol, Date, Time, ActiveSupport::TimeWithZone, ActiveSupport::TimeZone ]

    config.generators do |g|
      g.orm :active_record, primary_key_type: :uuid
      g.jbuilder false
    end

    if Settings[:postmark_key]
      config.action_mailer.delivery_method = :postmark
      config.action_mailer.postmark_settings = { api_token: Settings[:postmark_key] }
      config.action_mailbox.ingress = :postmark
    end

    # ROOT_URL is the full public URL of the instance (e.g. https://gather.example.com).
    # A bare hostname is accepted too, in which case the scheme/port are left alone.
    root_url = ENV["ROOT_URL"].presence
    root_uri = URI.parse(root_url) if root_url&.match?(%r{\A[a-z][a-z0-9+.-]*://}i)

    url_options =
      if root_uri
        { host: root_uri.host, protocol: root_uri.scheme }.tap do |options|
          options[:port] = root_uri.port unless root_uri.port == root_uri.default_port
        end
      else
        { host: root_url || "localhost" }
      end

    config.action_controller.default_url_options = url_options
    config.action_mailer.default_url_options = url_options
    Rails.application.routes.default_url_options.merge!(url_options)

    # Only restrict the Host header when ROOT_URL says what the host should be —
    # a non-empty config.hosts turns on DNS rebinding protection everywhere,
    # including tests, which reach the app over 127.0.0.1.
    config.hosts << url_options[:host] if root_url
  end
end

Dir[File.join(Rails.root, "lib", "patches", "*.rb")].each do |p|
  require p
end
