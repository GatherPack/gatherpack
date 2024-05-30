class Variable < ApplicationRecord
  TYPES = %i[ string int float structure ]

  validates :name, presence: true, format: { without: /\w/, message: 'must not have spaces' }
  validates :klass, presence: true, inclusion: { in: TYPES, message: 'is not valid'}

  def self.ransackable_attributes(auth_object = nil)
    ["klass", "name", "raw_value"]
  end

  def value
    nil if raw_value.blank?
    case klass
    when 'structure'
      JSON.parse(raw_value)
    when 'int'
      Integer(raw_value)
    when 'float'
      Float(raw_value)
    else
      raw_value
    end
  end
end
