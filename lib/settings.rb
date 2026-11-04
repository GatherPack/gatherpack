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
    end

    def value
      stored = Settings.instance.stored_values.fetch(setting_key, default_value)

      case setting_type
      when :boolean
        stored == "true"
      else
        stored
      end
    end

    def in_group?(group)
      group == @group
    end
  end

  class << self
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

    def register_feature(feature)
      instance.send(:add_feature_setting, feature)
    end
  end

  # The saved values, reloaded whenever the file changes, so a value saved by
  # another process (another Puma worker or the job runner) applies without a
  # restart. A file changed less than a second before it was loaded is read
  # again, since a second save in the same clock tick may not move its mtime.
  def stored_values
    path = store.path
    mtime = File.exist?(path) ? File.mtime(path) : nil
    loaded_path, loaded_mtime, loaded_at, values = @loaded

    return values if mtime && path == loaded_path && mtime == loaded_mtime && loaded_at - mtime > 1

    loaded_at = Time.now
    values = store.transaction(true) { store.roots.to_h { |key| [ key, store[key] ] } }
    @loaded = [ path, mtime, loaded_at, values ]
    values
  end

  private

  def add_feature_setting(feature)
    add_setting(
      feature.setting_key,
      :boolean,
      feature.label,
      feature.default_enabled.to_s,
      "Features",
      feature.description || "Enable or disable the #{feature.label} feature"
    )
  end

  def add_setting(setting_key, *args)
    @settings[setting_key] = Setting.new(@store, setting_key, *args)
  end

  def initialize
    # Thread safe, so Puma threads reading at the same time wait for each other
    # instead of raising PStore::Error ("nested transaction").
    @store = PStore.new("storage/settings.pstore", true)

    @settings = {}
    add_setting(:title, :string, "Site Name", "GatherPack", nil, "The name of the site")
    add_setting(:time_zone, :time_zone, "Time Zone", "Etc/UTC", nil, "The default time zone")
    add_setting(:infodump_day, :string, "Infodump Day", "Monday", nil, "The day of the week for the infodump to go out")
    add_setting(:infodump_time, :string, "Infodump Time", "5:30", nil, "The time of day for the infodump to go out (24h format)")

    add_setting(:local_auth, :boolean, "Enable Local Users", "true", "Local Auth", "Enable local log in capabilities")
    add_setting(:local_signup, :boolean, "Enable Creating Local Accounts", "true", "Local Auth", "Enable people to sign themselves up with an email & password")

    add_setting(:oauth_signup, :boolean, "Enable Creating OAuth Accounts", "true", "OAuth", "Enable people to sign themselves up with third party services")

    add_setting(:discord_oauth_client_id, :string, "Discord OAuth Client ID", "", "OAuth - Discord", "Client ID for Sign In via Discord")
    add_setting(:discord_oauth_client_secret, :string, "Discord OAuth Client Secret", "", "OAuth - Discord", "Client ID for Sign In via Discord")

    add_setting(:github_oauth_client_id, :string, "Github OAuth Client ID", "", "OAuth - Github", "Client ID for Sign In via Github")
    add_setting(:github_oauth_client_secret, :string, "Github OAuth Client Secret", "", "OAuth - Github", "Client ID for Sign In via Github")

    add_setting(:google_oauth_client_id, :string, "Google OAuth Client ID", "", "OAuth - Google", "Client ID for Sign In via Google")
    add_setting(:google_oauth_client_secret, :string, "Google OAuth Client Secret", "", "OAuth - Google", "Client ID for Sign In via Google")

    add_setting(:time_clock_max_hours, :integer, "Time Clock Max Shift Hours", "12", "Time Clock", "Shifts longer than this many hours are flagged for review")

    add_setting(:shirt_sizes, :string, "Shirt Sizes", "Youth S, Youth M, Youth L, S, M, L, XL, XXL, 3XL, 4XL", "People", "Comma-separated list of valid shirt sizes")
    add_setting(:gender_options, :string, "Gender Options", "M, F, X", "People", "Comma-separated list of valid gender options")
  end
end
