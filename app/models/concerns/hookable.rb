module Hookable
  extend ActiveSupport::Concern

  included do
    after_create { Hook.where(event: "#{self.table_name}.create").each { |h| h.run(self) } }
    after_update { Hook.where(event: "#{self.table_name}.update").each { |h| h.run(self) } }
    after_destroy { Hook.where(event: "#{self.table_name}.destroy").each { |h| h.run(self) } }
  end
end
