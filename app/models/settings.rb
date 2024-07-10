require "pstore"

class Settings
  include Singleton

  class Setting
    def initialize(store, setting_key, setting_type, name, default_value, group, description)
      @setting_key = setting_key
      @setting_type = setting_type || :text
      @name = name
      @value = store.transaction { store.fetch(setting_key, default_value) }
      @default_value = default_value
      @group = group || "Site Settings"
      @description = description || ""
    end

    def value=(val)
      store = Settings.instance.store
      store.transaction do
        store[@setting_key] = val
      end
      @value = val
    end

    def in_group?(group)
      group == @group
    end

    attr_reader :name, :setting_type, :description, :group, :setting_key, :value, :default_value
  end

  class <<self
    def [](setting)
      get(setting).value
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

  attr_accessor :store
  attr_reader :settings

  private
  def add_setting(setting_key, *args)
    @settings[setting_key] = Setting.new(@store, setting_key, *args)
  end

  def initialize
    @store = PStore.new("storage/settings.pstore") # NOTE: We may want to switch to using ActiveStorage

    @settings = Hash.new
    add_setting(:title, :string, "Site Name", "GatherPack", nil, "The name of the site")
  end
end