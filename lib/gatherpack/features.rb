module GatherPack
  module Features
    Section = Struct.new(:name, :position, keyword_init: true)

    # Module-level storage — loaded once via require_relative, not Zeitwerk-managed
    @sections = {}
    @built_ins = []
    @plugins = {}

    class << self
      def register_section(name, position:)
        @sections[name] = Section.new(name: name, position: position)
      end

      attr_reader :sections

      def register_built_in(feature)
        @built_ins << feature
        Settings.register_feature(feature) if feature.toggleable?
      end

      def register(feature)
        @plugins[feature.key] = feature
        Settings.register_feature(feature) if feature.toggleable?
      end

      def reset_built_ins!
        @built_ins = []
      end

      def all
        @built_ins + @plugins.values
      end

      def enabled?(key)
        feature = all.find { |f| f.key == key }
        feature ? feature.enabled? : false
      end

      def nav_sections
        enabled_with_nav = all.select { |f| f.enabled? && f.nav_section && f.nav_items.any? }

        grouped = enabled_with_nav.group_by(&:nav_section)

        grouped
          .sort_by { |name, _| @sections[name]&.position || Float::INFINITY }
          .map do |name, features|
            items = features.sort_by(&:nav_position).flat_map(&:nav_items)
            [ name, items ]
          end
      end

      def setup_sections
        enabled_with_setup = all.select { |f| f.enabled? && f.setup_section && f.setup_items.any? }

        grouped = enabled_with_setup.group_by(&:setup_section)

        grouped
          .sort_by { |name, _| @sections[name]&.position || Float::INFINITY }
          .map do |name, features|
            items = features.sort_by(&:nav_position).flat_map(&:setup_items)
            [ name, items ]
          end
      end
    end
  end
end
