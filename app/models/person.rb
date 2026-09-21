class Person < ApplicationRecord
  has_neat_id :per
  include CanBeHooked

  has_paper_trail versions: { class_name: "AuditLog" }
  belongs_to :user, optional: true
  has_many :memberships, dependent: :destroy
  has_many :membership_applications, dependent: :destroy
  has_many :teams, through: :memberships
  has_many :badge_assignments, dependent: :destroy
  has_many :badges, through: :badge_assignments
  has_many :checkins, dependent: :destroy
  has_many :events, through: :checkins
  has_many :tokens, as: :tokenable
  has_many :ledger_ownerships, dependent: :destroy, as: :owner
  has_many :time_clock_punches, dependent: :destroy
  has_many :calendar_notes, as: :noteable
  before_save :check_display_name
  accepts_nested_attributes_for :user
  has_one_attached :avatar
  attr_accessor :email

  def self.ransackable_attributes(auth_object = nil)
    [ "address", "birthday", "created_at", "dietary_restrictions", "display_name", "first_name", "gender", "id", "last_name", "phone_number", "shirt_size", "updated_at", "user_id" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "user", "tokens" ]
  end

  def admin?
    user&.admin
  end

  def architect?
    user&.architect
  end

  def manager?
    user&.admin || memberships.where(manager: true).any?
  end

  def roles
    roles = []
    roles << "admin" if user&.admin
    roles << "architect" if user&.architect
    roles << "manager" if memberships.where(manager: true).any?
    roles
  end

  def managed_teams
    user&.admin? ? Team.all : Team.joins(:memberships).where(memberships: { person_id: id, manager: true })
  end

  def managed_people
    user&.admin ? Person.all : Person.joins(:memberships).where(memberships: { team_id: managed_teams.select(:id) }).distinct
  end

  # Shared CTE definitions for "which teams can this person see".
  #
  #   descendants - everything at or below the teams they manage
  #   ancestors   - everything at or above the teams they belong to
  #
  # Walking this tree in Ruby (Team#all_descendants / #all_ancestors) costs one
  # query per node, which is tolerable on a page load but not when live search
  # re-runs the policy scope on every keystroke.
  VISIBLE_TEAM_CTES = <<~SQL.freeze
    descendants(id) AS (
      SELECT t.id FROM teams t
        JOIN memberships m ON m.team_id = t.id
        WHERE m.person_id = :person_id AND m.manager = TRUE
      UNION
      SELECT t.id FROM teams t JOIN descendants d ON t.parent_id = d.id
    ),
    ancestors(id, parent_id) AS (
      SELECT t.id, t.parent_id FROM teams t
        JOIN memberships m ON m.team_id = t.id
        WHERE m.person_id = :person_id
      UNION
      SELECT t.id, t.parent_id FROM teams t JOIN ancestors a ON t.id = a.parent_id
    ),
    visible(id) AS (
      SELECT id FROM descendants
      UNION
      SELECT id FROM ancestors
    )
  SQL

  VISIBLE_TEAM_IDS_SQL = <<~SQL.freeze
    WITH RECURSIVE
    #{VISIBLE_TEAM_CTES}
    SELECT id FROM visible
  SQL

  # The people this person is allowed to see: everyone in a visible team or
  # anywhere below it, plus the person themselves.
  #
  # The old Ruby version also added the managers of teams above the visible
  # ones. That is redundant - `visible` is closed under taking parents, so
  # those managers are already members of a team in `expanded`.
  VISIBLE_PERSON_IDS_SQL = <<~SQL.freeze
    WITH RECURSIVE
    #{VISIBLE_TEAM_CTES},
    expanded(id) AS (
      SELECT id FROM visible
      UNION
      SELECT t.id FROM teams t JOIN expanded e ON t.parent_id = e.id
    )
    SELECT m.person_id FROM memberships m WHERE m.team_id IN (SELECT id FROM expanded)
    UNION
    SELECT :person_id
  SQL

  # Ready-made WHERE fragments. Built here from the constants above so that
  # call sites pass a constant plus a real bind parameter, rather than
  # interpolating SQL inline.
  VISIBLE_TEAMS_CONDITION  = "teams.id IN (#{VISIBLE_TEAM_IDS_SQL})".freeze
  VISIBLE_PEOPLE_CONDITION = "people.id IN (#{VISIBLE_PERSON_IDS_SQL})".freeze

  def all_teams
    Team.where(VISIBLE_TEAMS_CONDITION, person_id: id)
  end

  def all_team_ids
    self.class.connection.select_values(
      self.class.sanitize_sql_array([ VISIBLE_TEAM_IDS_SQL, { person_id: id } ])
    )
  end

  def all_ancestor_teams
    Team.where(id: all_ancestor_team_ids)
  end

  def all_ancestor_team_ids
    direct_team_ids = teams.select(:id)
    ancestor_ids = Team.where(id: direct_team_ids).flat_map(&:all_ancestors).map(&:id)
    direct_team_ids + ancestor_ids
  end

  def all_managed_teams
    return Team.all if user&.admin?
    managed_team_ids = memberships.where(manager: true).pluck(:team_id)
    descendant_ids = Team.where(id: managed_team_ids).flat_map(&:all_descendant_ids)
    Team.where(id: managed_team_ids + descendant_ids)
  end

  def all_managed_people
    Person.joins(:memberships)
      .where(memberships: { team_id: all_managed_teams.select(:id) })
      .distinct
  end

  def relationships
    Relationship.where(parent_id: id).or(Relationship.where(child_id: id))
  end

  def relatives(relationship_type = nil)
    r = relationships
    r = r.where(relationship_type: relationship_type) if relationship_type
    relative_ids = r.pluck(:parent_id, :child_id).flatten.uniq - [ id ]
    Person.where(id: relative_ids)
  end

  def distant_relatives(relationship_type = nil)
    visited = Set.new([ id ])
    to_visit = relatives.to_a
    matching_relatives = []

    while to_visit.any?
      person = to_visit.pop
      next if visited.include?(person.id)
      visited << person.id
      if relationship_type
        rels = Relationship.where(
          "(parent_id = :a AND child_id = :b) OR (parent_id = :b AND child_id = :a)",
          a: person.id, b: id
        ).where(relationship_type: relationship_type)
        matching_relatives << person if rels.exists?
      else
        matching_relatives << person
      end
      to_visit.concat(person.relatives(nil).reject { |r| visited.include?(r.id) })
    end

    matching_relatives.uniq
  end

  def ledger_ids
    LedgerOwnership.where(owner: self).pluck(:ledger_id)
  end

  def ledgers
    Ledger.where(id: ledger_ids)
  end

  def current_time_clock_periods
    all_current_time_clock_periods = TimeClockPeriod.where("start_time <= ? AND end_time >= ?", Time.now, Time.now)
    all_current_time_clock_periods.where(team_id: all_team_ids)
      .or(all_current_time_clock_periods.where(team_id: nil))
  end

  def identifier_name
    display_name.presence || id
  end

  def identifier_icon
    "user"
  end

  def avatar_512
    avatar.variant(resize_to_fill: [ 512, 512 ], format: :jpg) if avatar.attached?
  end

  def avatar_64
    avatar.variant(resize_to_fill: [ 64, 64 ], format: :jpg) if avatar.attached?
  end

  private

  def check_display_name
    self.display_name = first_name + " " + last_name if display_name.blank? && !first_name.blank? && !last_name.blank?
  end
end
