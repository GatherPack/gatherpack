class Membership < ApplicationRecord
  has_neat_id :mbr
  include CanBeHooked
  has_paper_trail versions: { class_name: "AuditLog" }
  belongs_to :person
  belongs_to :team

  def self.ransackable_attributes(auth_object = nil)
    [ "manager", "person.display_name", "person.last_name", "person.first_name", "person.birthday", "updated_at" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "person" ]
  end

  def identifier_icon
  end

  def identifier_name
    "#{person.display_name} => #{team.name}"
  end
end
