class Account < ApplicationRecord
  include CanBeHooked
  has_paper_trail versions: { class_name: "AuditLog" }
  belongs_to :team, optional: true
  has_many :transactions
  has_many :account_relationships

  def self.ransackable_attributes(auth_object = nil)
    %w[ name team_id updated_at ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ 'team', 'person' ]
  end

  def balance
    Money.new(transactions.sum(:amount_cents))
  end

  def holders
    account_relationships.map(&:holder)
  end

  def holder_gids=(ids)
    account_holders = GlobalID::Locator.locate_many ids, only: [ Person, Event ]
    new_account_holders = account_holders - holders
    destroyed_account_holders = holders - account_holders

    account_relationships.where(holder: destroyed_account_holders).each do |h|
      h.destroy!
    end

    new_account_holders.each do |h|
      self.account_relationships.build(holder: h)
    end
  end

  def holder_gids
    holders.map { |h| h.to_global_id.to_s }
  end
end
