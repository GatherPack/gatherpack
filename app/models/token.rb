class Token < ApplicationRecord
  include CanBeHooked
  has_paper_trail versions: { class_name: "AuditLog" }
  belongs_to :tokenable, polymorphic: true, optional: true
  validates :value, uniqueness: true

  before_save :rfidify_value

  class << self
    # we have 2 different kinds of RFID readers that return the information on the cards in different formats...
    def rfidify(rfid)
      if rfid.to_s.match?(/\A5700[0-9a-fA-F]+\z/)
        rfid.to_s[4..-1].to_i(16).to_s
      else
        rfid
      end
    end

    def find_by_rfid(rfid)
      find_by(value: rfidify(rfid))
    end
  end

  def pretty_value
    "[#{value.to_s.last(8)}]"
  end

  def identifier_name
    "#{tokenable&.identifier_name || '***'} - #{pretty_value}"
  end

  def self.ransackable_attributes(auth_object = nil)
    [ 'created_at', 'id', 'tokenable_id', 'tokenable_type', 'updated_at', 'value' ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ 'tokenable' ]
  end

  private

  def rfidify_value
    self.value = Token.rfidify(value)
  end
end
