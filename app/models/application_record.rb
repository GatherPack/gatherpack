class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
  before_create :maybe_assign_id

  def identifier_name
    try(:display_name) || try(:name) || try(:title) || try(:id)
  end

  def to_combobox_display
    identifier_name
  end

  def identifier_icon
    "circle-question"
  end

  def method_missing(method_name, *args, &block)
    if method_name.to_s.end_with?("_gid=")
      relationship = method_name.to_s.chomp("_gid=")
      assign_global_id(relationship, args.first)
    elsif method_name.to_s.end_with?("_gids=")
      relationship = method_name.to_s.chomp("_gids=")
      assign_global_ids(relationship, args.first)
    else
      super
    end
  end

  def respond_to_missing?(method_name, include_private = false)
    method_name.to_s.end_with?("_gid=") || method_name.to_s.end_with?("_gids=") || super
  end

  private

  def assign_global_id(relationship, gid)
    model = GlobalID::Locator.locate(gid)
    if model
      send("#{relationship}=", model)
    else
      raise ArgumentError, "Could not locate model for Global ID: #{gid}"
    end
  end

  def assign_global_ids(relationship, gids)
    models = gids.map { |gid| GlobalID::Locator.locate(gid) }.compact
    if models.size == gids.size
      send("#{relationship}=", models)
    else
      raise ArgumentError, "One or more Global IDs could not be located: #{gids}"
    end
  end

  def maybe_assign_id
    self.id = SecureRandom.uuid if self.id.blank?
  end
end
