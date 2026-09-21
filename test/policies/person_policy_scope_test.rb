require "test_helper"

# Guards the rewrite of Person#all_team_ids and PersonPolicy::Scope from Ruby
# tree-walking to recursive CTEs.
#
# These two methods decide who can see whom, so a semantic drift here is a
# privacy bug rather than a performance regression. Every test asserts the SQL
# returns EXACTLY the set the old Ruby implementation did, against a team tree
# built here rather than from fixtures (the fixtures are flat scaffold output
# with no hierarchy, so they would exercise none of the recursion).
#
#   root
#   ├── engineering
#   │   ├── software
#   │   └── mechanical
#   └── outreach
#
class PersonPolicyScopeTest < ActiveSupport::TestCase
  def setup
    @team_type = TeamType.create!(name: "Subteam", icon: "people-group")

    @root        = Team.create!(name: "Root", team_type: @team_type)
    @engineering = Team.create!(name: "Engineering", team_type: @team_type, parent: @root)
    @software    = Team.create!(name: "Software", team_type: @team_type, parent: @engineering)
    @mechanical  = Team.create!(name: "Mechanical", team_type: @team_type, parent: @engineering)
    @outreach    = Team.create!(name: "Outreach", team_type: @team_type, parent: @root)

    @admin        = create_person("admin", admin: true)
    @root_manager = create_person("root-manager")
    @eng_manager  = create_person("eng-manager")
    @coder        = create_person("coder")
    @machinist    = create_person("machinist")
    @outreacher   = create_person("outreacher")
    @unaffiliated = create_person("unaffiliated")

    Membership.create!(person: @root_manager, team: @root, manager: true)
    Membership.create!(person: @eng_manager, team: @engineering, manager: true)
    Membership.create!(person: @coder, team: @software)
    Membership.create!(person: @machinist, team: @mechanical)
    Membership.create!(person: @outreacher, team: @outreach)
  end

  # --- Person#all_team_ids -------------------------------------------------

  test "visible team ids match the tree walk for a plain member" do
    assert_same_team_ids @coder
  end

  test "visible team ids match the tree walk for a manager with descendants" do
    assert_same_team_ids @eng_manager
  end

  test "visible team ids match the tree walk for a top level manager" do
    assert_same_team_ids @root_manager
  end

  test "visible team ids match the tree walk for someone with no teams" do
    assert_same_team_ids @unaffiliated
  end

  test "visible team ids match the tree walk for multiple memberships" do
    Membership.create!(person: @coder, team: @outreach)
    assert_same_team_ids @coder
  end

  # --- PersonPolicy::Scope -------------------------------------------------

  test "policy scope matches the tree walk for a plain member" do
    assert_same_people @coder
  end

  test "policy scope matches the tree walk for a manager with descendants" do
    assert_same_people @eng_manager
  end

  test "policy scope matches the tree walk for a top level manager" do
    assert_same_people @root_manager
  end

  test "policy scope matches the tree walk for someone with no teams" do
    assert_same_people @unaffiliated
  end

  test "admins see everyone" do
    assert_equal Person.count, scope_for(@admin).resolve.count
  end

  # --- Behaviour the CTE must preserve ------------------------------------

  test "a manager sees people in teams below theirs" do
    visible = scope_for(@eng_manager).resolve
    assert_includes visible, @coder, "manager of Engineering should see Software members"
    assert_includes visible, @machinist, "manager of Engineering should see Mechanical members"
  end

  # Characterises existing behaviour, which is broader than it first looks:
  # belonging to Software makes Root visible (it is an ancestor), and a
  # visible team expands to ALL of its descendants - so the Outreach branch
  # comes along too. Pre-existing, not introduced by the CTE rewrite; the
  # equivalence tests above prove old and new agree.
  test "visibility expands across sibling branches through a shared ancestor" do
    assert_includes scope_for(@eng_manager).resolve, @outreacher
    assert_includes scope_for(@coder).resolve, @outreacher
  end

  test "a plain member sees the managers above them" do
    visible = scope_for(@coder).resolve
    assert_includes visible, @eng_manager
    assert_includes visible, @root_manager
  end

  # The boundary that does hold: a separate tree is genuinely invisible.
  test "a member does not see people in an unconnected team tree" do
    other_root = Team.create!(name: "Other Org", team_type: @team_type)
    stranger = create_person("stranger")
    Membership.create!(person: stranger, team: other_root)

    refute_includes scope_for(@coder).resolve, stranger
    refute_includes scope_for(@root_manager).resolve, stranger
    assert_same_people @coder
  end

  test "everyone sees themselves" do
    assert_includes scope_for(@unaffiliated).resolve, @unaffiliated
  end

  # --- The point of the rewrite -------------------------------------------

  test "resolving the scope does not scale queries with tree depth" do
    scope = scope_for(@root_manager)
    queries = count_queries { scope.resolve.to_a }
    assert_operator queries, :<=, 2,
      "policy scope should be a single subquery, not one query per team in the tree"
  end

  test "the scope composes with ransack instead of materialising ids" do
    result = scope_for(@eng_manager).resolve.ransack(display_name_cont: "coder").result
    assert_equal [ @coder ], result.to_a
  end

  private

  def create_person(name, admin: false)
    user = User.create!(email: "#{name}@example.com", password: "password123", admin: admin)
    Person.create!(first_name: name, last_name: "Test", display_name: name, user: user)
  end

  def scope_for(person)
    PersonPolicy::Scope.new(person.user, Person)
  end

  # The pre-CTE implementations, kept here as the reference these tests check
  # the SQL against. They walk the tree in Ruby, which is why they were
  # replaced - but that also makes them an independent way to state the
  # expected result.
  def team_ids_by_tree_walk(person)
    direct = person.teams.select(:id)
    managed = person.memberships.where(manager: true).select(:team_id)
    descendants = Team.where(id: managed).flat_map(&:all_descendants).map(&:id)
    ancestors = Team.where(id: direct).flat_map(&:all_ancestors).map(&:id)
    (direct.map(&:id) + descendants + ancestors)
  end

  def people_by_tree_walk(person)
    return Person.all if person.user.admin

    teams = Team.where(id: team_ids_by_tree_walk(person))
    Person.where(id: (teams.map(&:all_people).flatten.map(&:id) << person.id)).distinct
  end

  def assert_same_team_ids(person)
    expected = team_ids_by_tree_walk(person).map(&:to_s).uniq.sort
    assert_equal expected, person.all_team_ids.map(&:to_s).uniq.sort,
      "CTE team ids diverged from the tree walk for #{person.display_name}"
  end

  def assert_same_people(person)
    expected = people_by_tree_walk(person).map(&:id).uniq.sort
    actual   = scope_for(person).resolve.map(&:id).uniq.sort
    assert_equal expected, actual,
      "CTE policy scope diverged from the tree walk for #{person.display_name}"
  end

  def count_queries(&block)
    count = 0
    counter = ->(_name, _start, _finish, _id, payload) do
      count += 1 unless payload[:name].in?([ "SCHEMA", "TRANSACTION" ])
    end
    ActiveSupport::Notifications.subscribed(counter, "sql.active_record", &block)
    count
  end
end
