class LedgerTransfer
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :from_ledger_id, :string
  attribute :to_ledger_id, :string
  attribute :amount, :decimal
  attribute :creator_id, :string
  attribute :creator_type, :string

  def from_ledger
    Ledger.find(from_ledger_id)
  end

  def to_ledger
    Ledger.find(to_ledger_id)
  end

  def creator
    creator_type.constantize.find(creator_id)
  end

  def creator=(obj)
    self.creator_type = obj.class.to_s
    self.creator_id = obj.id
  end

  def create
    t = LedgerEntry.create(ledger: from_ledger, amount: amount, remark: "Transfer to #{to_ledger.name}", created_by: creator, transfer_mirror: true)
    f = LedgerEntry.create(ledger: to_ledger, amount: amount, remark: "Transfer from #{from_ledger.name}", created_by: creator)

    LedgerEntryLink.create(ledger_entries: [ t, f ])
  end
end
