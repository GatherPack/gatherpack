class Team < ApplicationRecord
  has_neat_id :tm
  include CanBeHooked
  has_paper_trail versions: { class_name: "AuditLog" }
  belongs_to :team_type
  has_many :announcements
  has_many :badges
  has_many :events
  has_many :memberships, dependent: :destroy
  has_many :people, through: :memberships
  has_many :events
  has_many :pages
  belongs_to :parent, class_name: "Team", optional: true
  has_many :children, class_name: "Team", foreign_key: :parent_id, dependent: :nullify
  has_many :calendar_notes, as: :noteable
  enum :join_permission, { added_by_admin: 0, added_by_manager: 1, added_by_current_member: 2, has_account: 3 }

  validates :name, presence: true
  validates :join_permission, inclusion: { in: join_permissions.keys }

  scope :top_level, -> { where(parent_id: nil) }

  def self.ransackable_scopes(auth_object = nil)
    [ :top_level ]
  end

  def self.ransackable_conditions(auth_object = nil)
    [ "team_type_id", "parent_id" ]
  end

  def self.ransackable_attributes(auth_object = nil)
    [ "name", "team_type_id", "updated_at", "people.count", "parent_id", "join_permission" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "team_type", "parent" ]
  end

  def all_descendant_ids
    children.flat_map { |child| [ child.id ] + child.all_descendant_ids }
  end

  def all_descendants
    children.flat_map { |child| [ child ] + child.all_descendants }
  end

  def all_ancestor_ids
    parent ? [ parent.id ] + parent.all_ancestor_ids : []
  end

  def all_ancestors
    parent ? [ parent ] + parent.all_ancestors : []
  end

  def ancestor_manager_ids
    Person.joins(:memberships)
      .where(memberships: { team_id: all_ancestor_ids, manager: true })
      .select("people.id")
  end

  def descendant_member_ids
    Person.joins(:memberships)
      .where(memberships: { team_id: all_descendant_ids + [ id ] })
      .select("people.id")
      .distinct
  end

  def all_people
    Person.joins(:memberships)
      .where(memberships: { team_id: all_descendant_ids + [ id ] })
      .or(Person.where(id: ancestor_manager_ids))
      .distinct
  end

  def all_managers
    ancestor_ids = [ id ] + all_ancestor_ids
    Person.joins(:memberships).joins(:user).where(memberships: { team_id: ancestor_ids, manager: true }).distinct
  end

  def all_managers_and_admins
    ancestor_ids = [ id ] + all_ancestor_ids
    Person.joins(:memberships).joins(:user).where(memberships: { team_id: ancestor_ids, manager: true }).or(Person.where(user: { admin: true })).distinct
  end

  def manager?(person)
    all_managers_and_admins.include?(person)
  end

  def identifier_icon
    "people-group"
  end
end
