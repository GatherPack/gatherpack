require "test_helper"
require "support/authentication_helper"

# Every page that carries a search form renders the shared filter bar, and
# still renders when a search is applied.
#
# Eight of these used to 500: their models never allowlisted anything for
# Ransack, so `.ransack` raised on load.
class FilterBarSmokeTest < ActionDispatch::IntegrationTest
  include AuthenticationHelper

  def setup
    @team_type = TeamType.create!(name: "Subteam", icon: "people-group")
    @team = Team.create!(name: "Engineering", team_type: @team_type, color: "#336699")

    @user = User.create!(email: "smoke@example.com", password: "password123", admin: true)
    @person = Person.create!(first_name: "Ada", last_name: "Admin",
                             display_name: "Ada Admin", user: @user)
    Membership.create!(person: @person, team: @team, manager: true)

    @badge_type = BadgeType.create!(name: "Skill")
    @badge = Badge.create!(name: "Driver", short: "anchor", color: "#2ec27e",
                           badge_type: @badge_type, team: @team)
    @ledger = Ledger.create!(name: "Main", team: @team)
    @mailbox = Mailbox.create!(address: "team@example.com")
    @period = TimeClockPeriod.create!(name: "Season", team: @team,
                                      start_time: 1.day.ago, end_time: 1.day.from_now)
    @event_type = EventType.create!(name: "Meeting")
    @event = Event.create!(name: "Kickoff", location: "Shop", event_type: @event_type,
                           team: @team, start_time: 1.day.from_now, end_time: 2.days.from_now)

    sign_in_as @user
  end

  # path => the search param that page's primary input uses
  def pages
    {
      announcements_path            => { title_or_content_i_cont: "x" },
      audit_logs_path               => { item_type_eq: "Team" },
      badge_types_path              => { name_cont: "x" },
      badges_path                   => { name_or_description_or_short_cont: "x" },
      budget_periods_path           => { name_cont: "x" },
      budgets_path                  => {},
      calendar_index_path           => { name_or_location_i_cont: "x" },
      calendar_notes_path           => { name_i_cont: "x" },
      checkin_fields_path           => { name_cont: "x" },
      event_types_path              => { name_i_cont: "x" },
      events_path                   => { name_or_location_i_cont: "x" },
      hooks_path                    => { name_i_cont: "x" },
      ledger_entry_links_path       => {},
      ledger_tags_path              => { name_cont: "x" },
      ledgers_path                  => { name_cont: "x" },
      mailboxes_path                => { address_cont: "x" },
      pages_path                    => { title_or_content_cont: "x" },
      people_path                   => { display_name_cont: "x" },
      questions_path                => { title_i_cont: "x" },
      relationship_types_path       => { child_label_or_parent_label_cont: "x" },
      reports_path                  => { name_i_cont: "x" },
      shortcuts_path                => { name_cont: "x" },
      team_types_path               => { name_i_cont: "x" },
      teams_path                    => { name_cont: "x" },
      time_clock_periods_path       => { name_cont: "x" },
      time_clock_punches_path       => { person_display_name_cont: "x" },
      tokens_path                   => { tokenable_of_Person_type_display_name_cont: "x" },
      variables_path                => { name_cont: "x" },
      badge_badge_assignments_path(@badge)   => {},
      ledger_ownerships_path(@ledger)        => {},
      team_memberships_path(@team)           => { display_name_cont: "x" },
      mailbox_path(@mailbox)                 => { subject_or_body_or_from_cont: "x" },
      time_clock_period_path(@period)        => { person_display_name_cont: "x" },
      event_path(@event)                     => { person_display_name_cont: "x" }
    }
  end

  test "every search page renders the shared filter bar" do
    pages.each_key do |path|
      get path
      assert_response :success, "GET #{path} did not succeed"
      assert_select ".filter-bar", { minimum: 1 }, "no filter bar on #{path}"
    end
  end

  test "every search page still renders with a search applied" do
    pages.each do |path, query|
      next if query.empty?

      get path, params: { q: query }
      assert_response :success, "GET #{path} with #{query.inspect} did not succeed"
      assert_select ".filter-bar", { minimum: 1 }, "no filter bar on filtered #{path}"
    end
  end

  test "a filter over plain strings renders a readable chip" do
    # Regression: chips resolved a value by calling .id on each option, which
    # blew up for collections of bare strings (Variable::TYPES, Hook.catalog,
    # the audit log's event list).
    Variable.create!(name: "site_name", klass: "string", raw_value: %("Team"))

    get variables_path, params: { q: { klass_eq: "string" } }

    assert_response :success
    assert_select ".filter-chip .filter-chip__value", text: "string"
  end

  test "pages with nothing worth filtering on have no filter panel" do
    # Team Types only had an icon filter, which is not a dimension anyone
    # filters by; with it gone the page should not offer an empty panel.
    get team_types_path

    assert_response :success
    assert_select ".filter-bar__search-input", 1
    assert_select ".filter-bar__toggle", 0, "team types should not show a Filters button"
  end

  test "the empty state pluralises its noun properly" do
    # Regression: the noun was pluralised by appending "s", which produced
    # "no punchs yet" and "no entrys yet".
    get time_clock_period_path(@period)

    assert_response :success
    assert_select ".no-results__message", text: /no punches yet/
    assert_select ".no-results__message", { text: /punchs/, count: 0 }
  end

  test "sorting is accepted on every search page" do
    pages.each_key do |path|
      get path, params: { q: { s: "updated_at desc" } }
      assert_response :success, "GET #{path} sorted did not succeed"
    end
  end
end
