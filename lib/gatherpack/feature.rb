module GatherPack
  class Feature
    NavItem = Struct.new(:label, :path, :icon, keyword_init: true)
    SetupItem = Struct.new(:label, :path, :policy_check, keyword_init: true)

    attr_reader :key, :label, :description, :default_enabled, :toggleable,
      :nav_section, :nav_position, :nav_items, :setup_section, :setup_items,
      :routes_proc

    def initialize(key:, label:, description: nil, default_enabled: true,
      toggleable: true, nav_section: nil, nav_position: 50,
      nav_items: [], setup_section: nil, setup_items: [], routes_proc: nil)
      @key = key
      @label = label
      @description = description
      @default_enabled = default_enabled
      @toggleable = toggleable
      @nav_section = nav_section
      @nav_position = nav_position
      @nav_items = Array(nav_items)
      @setup_section = setup_section
      @setup_items = Array(setup_items)
      @routes_proc = routes_proc
    end

    def toggleable?
      @toggleable
    end

    def enabled?
      toggleable? ? Settings[:"feature_#{key}"] : true
    end

    def setting_key
      :"feature_#{key}"
    end
  end
end
