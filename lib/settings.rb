require "pstore"

class Settings
  include Singleton

  attr_accessor :store
  attr_reader :settings

  class Setting
    attr_reader :name, :setting_type, :description, :group, :setting_key, :default_value

    def initialize(store, setting_key, setting_type, name, default_value, group, description)
      @setting_key = setting_key
      @setting_type = setting_type || :text
      @name = name
      @value = store.transaction { store.fetch(setting_key, default_value) }
      @default_value = default_value
      @group = group || "Site Settings"
      @description = description || ""

      store.transaction do
        store[@setting_key] ||= default_value
      end
    end

    def value=(val)
      store = Settings.instance.store
      store.transaction do
        store[@setting_key] = val
      end
      @value = val
    end

    def value
      case setting_type
      when :boolean
        @value == "true"
      else
        @value
      end
    end

    def in_group?(group)
      group == @group
    end
  end

  class <<self
    def [](setting)
      get(setting)&.value
    end

    def get(setting)
      instance.settings[setting]
    end

    def set(setting, val)
      instance.settings[setting].value = val
    end

    def []=(*args)
      set(*args)
    end

    def settings(group)
      instance.settings.values.filter { |setting| setting.in_group? group }
    end

    def groups
      instance.settings.values.map(&:group).uniq
    end
  end

  private

  def add_setting(setting_key, *args)
    @settings[setting_key] = Setting.new(@store, setting_key, *args)
  end

  def initialize
    @store = PStore.new("storage/settings.pstore")

    @settings = Hash.new
    add_setting(:title, :string, "Site Name", "GatherPack", nil, "The name of the site")
    add_setting(:time_zone, :time_zone, "Time Zone", "Etc/UTC", nil, "The default time zone")

    add_setting(:from_email, :string, "From Email", "noreply@gatherpack.com", "Email", "Email address that system emails come from")
    add_setting(:postmark_key, :string, "Postmark API Key", nil, "Email", "API Key for sending email through PostMark")
    add_setting(:incoming_email_secret, :string, "Incoming Email Secret", "gatheremail", "Email", '"Password" for validating incoming email API requests')

    add_setting(:local_auth, :boolean, "Enable Local Users", "true", "Local Auth", "Enable local log in capabilities")
    add_setting(:local_signup, :boolean, "Enable Creating Local Accounts", "true", "Local Auth", "Enable people to sign themselves up with an email & password")

    add_setting(:oauth_signup, :boolean, "Enable Creating OAuth Accounts", "true", "OAuth", "Enable people to sign themselves up with third party services")

    add_setting(:discord_oauth_client_id, :string, "Discord OAuth Client ID", "", "OAuth - Discord", "Client ID for Sign In via Discord")
    add_setting(:discord_oauth_client_secret, :string, "Discord OAuth Client Secret", "", "OAuth - Discord", "Client ID for Sign In via Discord")

    add_setting(:github_oauth_client_id, :string, "Github OAuth Client ID", "", "OAuth - Github", "Client ID for Sign In via Github")
    add_setting(:github_oauth_client_secret, :string, "Github OAuth Client Secret", "", "OAuth - Github", "Client ID for Sign In via Github")

    add_setting(:google_oauth_client_id, :string, "Google OAuth Client ID", "", "OAuth - Google", "Client ID for Sign In via Google")
    add_setting(:google_oauth_client_secret, :string, "Google OAuth Client Secret", "", "OAuth - Google", "Client ID for Sign In via Google")

    add_setting(:shirt_sizes, :string, "Shirt Sizes", "Youth S, Youth M, Youth L, S, M, L, XL, XXL, 3XL, 4XL", "People", "Comma-separated list of valid shirt sizes")
    add_setting(:gender_options, :string, "Gender Options", "M, F, X", "People", "Comma-separated list of valid gender options")
  end
end
