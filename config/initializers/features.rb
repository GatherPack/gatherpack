# Uses config.to_prepare so registrations are replayed on each development
# reload (Zeitwerk reloads app/ code between requests in development, but
# GatherPack::Features lives in lib/ and is loaded once; to_prepare ensures
# @built_ins stays current).
#
# Plugin gems should register their own features in a Railtie initializer
# that runs after :load_config_initializers:
#
#   initializer "myplugin.register_features", after: :load_config_initializers do
#     GatherPack::Features.register(
#       GatherPack::Feature.new(
#         key:         :my_feature,
#         label:       "My Feature",
#         nav_section: "Content",
#         nav_position: 99,
#         nav_items:   [GatherPack::Feature::NavItem.new(
#                         label: "Things",
#                         path:  -> { MyPlugin::Engine.routes.url_helpers.things_path },
#                         icon:  "star"
#                       )],
#         routes_proc: proc { mount MyPlugin::Engine, at: "/my_plugin" }
#       )
#     )
#   end

Rails.application.config.to_prepare do
  GatherPack::Features.reset_built_ins!

  # ---------------------------------------------------------------------------
  # Section ordering
  # ---------------------------------------------------------------------------
  GatherPack::Features.register_section("People", position: 10)
  GatherPack::Features.register_section("Time", position: 20)
  GatherPack::Features.register_section("Finance", position: 30)
  GatherPack::Features.register_section("Communication", position: 40)
  GatherPack::Features.register_section("Content", position: 50)

  # ---------------------------------------------------------------------------
  # Core (always-on) features
  # ---------------------------------------------------------------------------

  GatherPack::Features.register_built_in(
    GatherPack::Feature.new(
      key: :people_core,
      label: "People & Teams",
      toggleable: false,
      nav_section: "People",
      nav_position: 10,
      nav_items: [
        GatherPack::Feature::NavItem.new(label: "People", path: :people_path, icon: "users"),
        GatherPack::Feature::NavItem.new(label: "Teams", path: :teams_path, icon: "people-group")
      ],
      setup_section: "People",
      setup_items: [
        GatherPack::Feature::SetupItem.new(label: "Team Types", path: :team_types_path),
        GatherPack::Feature::SetupItem.new(label: "Relationship Types", path: :relationship_types_path)
      ]
    )
  )

  GatherPack::Features.register_built_in(
    GatherPack::Feature.new(
      key: :content_core,
      label: "Announcements & Shortcuts",
      toggleable: false,
      nav_section: "Content",
      nav_position: 10,
      nav_items: [
        GatherPack::Feature::NavItem.new(label: "Announcements", path: :announcements_path, icon: "comment"),
        GatherPack::Feature::NavItem.new(label: "Shortcuts", path: :shortcuts_path, icon: "link")
      ]
    )
  )

  # ---------------------------------------------------------------------------
  # Toggleable features
  # ---------------------------------------------------------------------------

  GatherPack::Features.register_built_in(
    GatherPack::Feature.new(
      key: :badges,
      label: "Badges",
      description: "Issue badges and credentials to members",
      default_enabled: true,
      nav_section: "People",
      nav_position: 20,
      nav_items: [
        GatherPack::Feature::NavItem.new(label: "Badges", path: :badges_path, icon: "certificate")
      ],
      setup_section: "People",
      setup_items: [
        GatherPack::Feature::SetupItem.new(label: "Badge Types", path: :badge_types_path)
      ]
    )
  )

  GatherPack::Features.register_built_in(
    GatherPack::Feature.new(
      key: :tokens,
      label: "Tokens",
      description: "Manage RFID and access tokens for members",
      default_enabled: true,
      nav_section: "People",
      nav_position: 30,
      nav_items: [
        GatherPack::Feature::NavItem.new(label: "Tokens", path: :tokens_path, icon: "id-badge")
      ]
    )
  )

  GatherPack::Features.register_built_in(
    GatherPack::Feature.new(
      key: :events,
      label: "Events & Calendar",
      description: "Track events, attendance check-ins, and the team calendar",
      default_enabled: true,
      nav_section: "Time",
      nav_position: 10,
      nav_items: [
        GatherPack::Feature::NavItem.new(label: "Calendar", path: :calendar_index_path, icon: "calendar")
      ],
      setup_section: "Time",
      setup_items: [
        GatherPack::Feature::SetupItem.new(label: "Event Types", path: :event_types_path),
        GatherPack::Feature::SetupItem.new(label: "Checkin Fields", path: :checkin_fields_path)
      ]
    )
  )

  GatherPack::Features.register_built_in(
    GatherPack::Feature.new(
      key: :time_tracking,
      label: "Time Tracking",
      description: "Time clock punch-in/out and shift period management",
      default_enabled: true,
      nav_section: "Time",
      nav_position: 20,
      nav_items: [
        GatherPack::Feature::NavItem.new(label: "Time Clock", path: :time_clock_punches_path, icon: "business-time")
      ]
    )
  )

  GatherPack::Features.register_built_in(
    GatherPack::Feature.new(
      key: :ledger,
      label: "Ledger",
      description: "Financial ledgers, transactions, and payment gateways",
      default_enabled: true,
      nav_section: "Finance",
      nav_position: 10,
      nav_items: [
        GatherPack::Feature::NavItem.new(label: "Ledgers", path: :ledgers_path, icon: "receipt")
      ],
      setup_section: "Finance",
      setup_items: [
        GatherPack::Feature::SetupItem.new(label: "Ledger Tags", path: :ledger_tags_path),
        GatherPack::Feature::SetupItem.new(label: "Gateways", path: :gateways_path,
          policy_check: ->(view) { view.policy(Gateway).create? })
      ]
    )
  )

  GatherPack::Features.register_built_in(
    GatherPack::Feature.new(
      key: :budgets,
      label: "Budgets",
      description: "Budget periods and spending limits per ledger tag",
      default_enabled: true,
      nav_section: "Finance",
      nav_position: 20,
      nav_items: [
        GatherPack::Feature::NavItem.new(label: "Budgets", path: :budgets_path, icon: "wallet")
      ]
    )
  )

  GatherPack::Features.register_built_in(
    GatherPack::Feature.new(
      key: :mailboxes,
      label: "Mailboxes",
      description: "Inbound email mailboxes for teams and people",
      default_enabled: true,
      nav_section: "Communication",
      nav_position: 10,
      nav_items: [
        GatherPack::Feature::NavItem.new(label: "Mailboxes", path: :mailboxes_path, icon: "inbox")
      ]
    )
  )

  GatherPack::Features.register_built_in(
    GatherPack::Feature.new(
      key: :pages,
      label: "Pages",
      description: "Static and dynamic content pages",
      default_enabled: true,
      nav_section: "Content",
      nav_position: 20,
      nav_items: [
        GatherPack::Feature::NavItem.new(label: "Pages", path: :pages_path, icon: "file-lines")
      ]
    )
  )
end
