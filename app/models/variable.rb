class Variable < ApplicationRecord
  has_neat_id :var
  has_paper_trail versions: { class_name: "AuditLog" }

  TYPES = %w[ string int float structure ]

  validates :name, presence: true, format: { without: /\W/, message: "must not have spaces" }
  validates :klass, presence: true, inclusion: { in: TYPES, message: "is not valid" }

  def self.ransackable_attributes(auth_object = nil)
    [ "klass", "name", "raw_value", "updated_at"  ]
  end

  def value
    nil if raw_value.blank?
    case klass
    when "structure"
      begin
        JSON.parse(raw_value)
      rescue JSON::ParserError
        { "value"=>raw_value }
      end
    when "int"
      raw_value.to_i
    when "float"
      raw_value.to_f
    else
      raw_value
    end
  end

  def identifier_icon
    "database"
  end
end
