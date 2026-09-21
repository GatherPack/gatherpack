require "application_system_test_case"

# Covers the behaviour the live search redesign exists to provide. These are
# the first tests in the suite that exercise search at all.
class LiveSearchTest < ApplicationSystemTestCase
  SEARCH_FIELD = "q_display_name_cont".freeze

  def setup
    @team_type = TeamType.create!(name: "Subteam", icon: "people-group")
    @team = Team.create!(name: "Engineering", team_type: @team_type, color: "#336699")

    @admin_user = User.create!(email: "admin@example.com", password: "password123", admin: true)
    @admin = Person.create!(first_name: "Ada", last_name: "Admin",
                            display_name: "Ada Admin", user: @admin_user)

    @doherty = Person.create!(first_name: "Jack", last_name: "Doherty",
                              display_name: "Jack Doherty")
    @lovelace = Person.create!(first_name: "Grace", last_name: "Lovelace",
                               display_name: "Grace Lovelace")

    sign_in_as @admin_user
  end

  test "typing narrows results without pressing a button" do
    visit people_path
    assert_text "Jack Doherty"
    assert_text "Grace Lovelace"

    fill_in SEARCH_FIELD, with: "Doherty"

    assert_text "Jack Doherty"
    assert_no_text "Grace Lovelace"
  end

  test "there is no search button to press" do
    visit people_path
    # Scoped to the filter bar: the navbar's global search is a separate
    # surface and still has its own Search button.
    within(".filter-bar") { assert_no_button "Search" }
  end

  test "the search input keeps focus while results update" do
    visit people_path
    fill_in SEARCH_FIELD, with: "Doherty"
    assert_no_text "Grace Lovelace" # wait for the frame to have swapped

    assert_equal SEARCH_FIELD, page.evaluate_script("document.activeElement.id"),
      "the turbo-frame update must not steal focus from the search input"
  end

  test "the url reflects the live search so it can be reloaded" do
    visit people_path
    fill_in SEARCH_FIELD, with: "Doherty"
    assert_no_text "Grace Lovelace"

    assert_match(/q%5Bdisplay_name_cont%5D=Doherty|q\[display_name_cont\]=Doherty/, page.current_url)

    visit page.current_url
    assert_text "Jack Doherty"
    assert_no_text "Grace Lovelace"
  end

  test "the result count updates with the search" do
    visit people_path
    # Not an absolute count: fixtures :all loads scaffold people too.
    assert_text(/\d+ people/)

    fill_in SEARCH_FIELD, with: "Doherty"
    assert_text "1 person"
  end

  test "a search with no matches offers a way out" do
    visit people_path
    fill_in SEARCH_FIELD, with: "Nobody By This Name"

    assert_text "No people match these filters."
    click_on "Clear all filters"
    assert_text "Jack Doherty"
  end

  test "clearing restores the full list" do
    visit people_path
    fill_in SEARCH_FIELD, with: "Doherty"
    assert_no_text "Grace Lovelace"

    click_on "Clear"
    assert_text "Grace Lovelace"
    assert_equal "", find("##{SEARCH_FIELD}").value
  end

  test "a filter renders as a removable chip on teams" do
    other_type = TeamType.create!(name: "Committee", icon: "gavel")
    Team.create!(name: "Outreach", team_type: other_type, color: "#993366")

    visit teams_path(filter: "all", q: { team_type_id_eq: @team_type.id })

    # Label and value are separate spans, so match them on the chip element
    # rather than as one run of text.
    assert_selector ".filter-chip", text: "Team Type"
    assert_selector ".filter-chip", text: "Subteam"
    assert_text "Engineering"
    assert_no_text "Outreach"

    find(".filter-chip", text: "Team Type").click

    assert_no_selector ".filter-chip", text: "Team Type"
    assert_text "Outreach"
  end

  test "events filters live on a secondary text field" do
    event_type = EventType.create!(name: "Meeting")
    Event.create!(name: "Kickoff", event_type: event_type, location: "Shop",
                  start_time: 1.day.from_now, end_time: 2.days.from_now)
    Event.create!(name: "Retro", event_type: event_type, location: "Library",
                  start_time: 1.day.from_now, end_time: 2.days.from_now)

    visit events_path
    assert_text "Kickoff"
    assert_text "Retro"

    # Secondary filters start collapsed when none are applied.
    click_on "Filters"

    # location_i_cont is a secondary *string* filter, so it debounces like the
    # primary search rather than firing on change.
    fill_in "q_location_i_cont", with: "Library"

    assert_text "Retro"
    assert_no_text "Kickoff"
    assert_selector ".filter-chip", text: "Location"
  end

  test "the empty state's clear button also empties the search box" do
    visit people_path
    fill_in "q_display_name_cont", with: "zzzznothingmatchesthis"
    assert_text "No people match these filters"

    click_on "Clear all filters"

    # Regression: this button renders inside the turbo-frame while the search
    # box lives outside it, so without turbo_frame: "_top" the results came
    # back unfiltered while the typed text stayed in the box - leaving the page
    # showing everything with a stale search term, and the next keystroke
    # re-applying it.
    assert_text "Jack Doherty"
    assert_field "q_display_name_cont", with: ""
    assert_no_selector ".filter-chip"
  end

  test "a non-Ransack filter gets a chip too" do
    Team.create!(name: "Outreach", team_type: @team_type, color: "#2c7873")
    visit teams_path

    # "My Teams" is the default, so it is not a filter the user applied.
    assert_no_selector ".filter-chip"
    assert_no_selector ".filter-bar__count:not([hidden])"

    click_on "Filters"
    select "All Teams", from: "filter"

    assert_selector ".filter-chip", text: "Show"
    assert_selector ".filter-chip", text: "All Teams"
    assert_text "Outreach"

    find(".filter-chip").click

    assert_no_selector ".filter-chip"
    assert_no_text "Outreach"
  end

  test "a filter left at its default does not count as applied" do
    question_team = @team
    Question.create!(title: "Open one", content: "…", team: question_team, person: @admin)

    visit questions_path

    # Questions default to Open; that should not light up the Filters badge.
    assert_no_selector ".filter-bar__count:not([hidden])"
    assert_no_selector ".filter-chip"

    click_on "Filters"
    select "Closed", from: "q_closed_eq"

    assert_selector ".filter-bar__count", text: "1"
    assert_selector ".filter-chip", text: "Status"
    assert_selector ".filter-chip", text: "Closed"

    # "All" is also a departure from the default, so it chips too.
    select "All", from: "q_closed_eq"

    assert_selector ".filter-bar__count", text: "1"
    assert_selector ".filter-chip", text: "Status"
    assert_selector ".filter-chip", text: "All"

    # Removing it puts the page back to its default, with nothing applied.
    find(".filter-chip", text: "Status").click

    assert_no_selector ".filter-chip"
    assert_no_selector ".filter-bar__count:not([hidden])"
    assert_equal "false", find("#q_closed_eq").value
  end

  test "the question status filter switches between all, open and closed" do
    open_q = Question.create!(title: "Still open", content: "…", team: @team, person: @admin)
    closed_q = Question.create!(title: "Already closed", content: "…", team: @team,
                                person: @admin, closed: true)

    visit questions_path

    # Defaults to Open.
    assert_text open_q.title
    assert_no_text closed_q.title

    click_on "Filters"

    select "All", from: "q_closed_eq"
    assert_text open_q.title
    assert_text closed_q.title

    select "Closed", from: "q_closed_eq"
    assert_text closed_q.title
    assert_no_text open_q.title

    select "Open", from: "q_closed_eq"
    assert_text open_q.title
    assert_no_text closed_q.title
  end

  test "the sort menu opens on a page that also has secondary filters" do
    # Regression: the Filters count used Bootstrap's .badge, and _badges.scss
    # sets `div:has(.badge):not(.table-responsive) { overflow: hidden }`. That
    # applies to every ancestor div, so the card clipped the open dropdown -
    # the menu got its .show class but was never visible. People has no
    # secondary filters and so was unaffected, which is what made this look
    # like a Teams-only bug.
    visit teams_path

    find(".filter-bar__sort > button").click

    assert_selector ".filter-bar__sort .dropdown-menu", visible: true
    assert_selector ".filter-bar__sort .dropdown-menu a", text: "Name", visible: true
  end

  test "the sort menu marks exactly one attribute as sorted" do
    # Regression: a two-element default (["last_name asc", "first_name asc"])
    # made sort_link draw a direction arrow on both entries at once. The
    # tiebreaker belongs on the relation, not in q.sorts.
    visit people_path

    find(".filter-bar__sort > button").click
    menu = find(".filter-bar__sort .dropdown-menu")

    assert_equal 1, menu.text.scan(/[\u25B2\u25BC]/).size,
                 "expected one sort-direction arrow, got: #{menu.text.inspect}"
  end

  test "the sort control shows the current sort" do
    visit people_path
    assert_text "Last Name ↑"
  end
end
