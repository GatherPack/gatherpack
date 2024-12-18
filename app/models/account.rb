class Account < ApplicationRecord
  include CanBeHooked
  has_paper_trail versions: { class_name: "AuditLog" }
  belongs_to :team, optional: true
  has_many :transactions
  has_many :account_relationships

  def self.ransackable_attributes(auth_object = nil)
    %w[ name team_id ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ 'team' ]
  end

  def balance
    Money.new(transactions.sum(:amount_cents))
  end

  def holders
    account_relationships.map(&:holder)
  end
end
