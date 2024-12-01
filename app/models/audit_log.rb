class AuditLog < AbstractVersion
  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "event", "id", "item_id", "item_type", "object", "object_changes", "whodunnit"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["item"]
  end
end
