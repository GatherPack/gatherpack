class Token < ApplicationRecord
  belongs_to :tokenable, polymorphic: true

  def pretty_value
    "[#{value[-8..-1]}]"
  end

  def identifier_name
    "#{tokenable.identifier_name} - #{pretty_value}"
  end

  def self.ransackable_attributes(auth_object = nil)
    [ 'created_at', 'id', 'tokenable_id', 'tokenable_type', 'updated_at', 'value' ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ 'tokenable' ]
  end
end
