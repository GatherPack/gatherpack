require_relative 'boot'
ENV['RANSACK_FORM_BUILDER'] = '::SimpleForm::FormBuilder'
require 'rails/all'

require_relative '../lib/settings.rb'

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
    config.autoload_lib(ignore: %w[assets tasks generators templates middleware])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

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

    config.mission_control.jobs.http_basic_auth_enabled = false
  end
end

Dir[File.join(Rails.root, 'lib', 'patches', '*.rb')].each do |p|
  require p
end
