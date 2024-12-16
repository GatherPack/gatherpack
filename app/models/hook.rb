class Hook < ApplicationRecord
  has_paper_trail versions: { class_name: "AuditLog" }

  validates :name, presence: true

  def self.catalog
    targets = ['announcements', 'badges', 'badge_assignments', 'events', 'checkin', 'memberships', 'people', 'relationships', 'teams', 'users', 'accounts', 'transactions', 'page', 'token'].map do |k|
      ['create', 'update', 'destroy'].map { |e| [k.singularize, e].join(' - ') }
    end.flatten
    
    targets << 'token - activate'

    targets.sort
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[ name event ]
  end
end
