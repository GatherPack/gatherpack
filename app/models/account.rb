class Account < ApplicationRecord
  include CanBeHooked
  has_paper_trail versions: { class_name: "AuditLog" }
  belongs_to :team, optional: true
  has_many :transactions
  has_many :account_relationships

  def balance
    Money.new(transactions.sum(:amount_cents))
  end

  def holders
    account_relationships.map(&:holder)
  end
end
