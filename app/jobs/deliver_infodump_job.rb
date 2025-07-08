class DeliverInfodumpJob < ApplicationJob
  queue_as :default

  def perform(person)
    infodump = Infodump.new(person)
    infodump.generate
    infodump.send
  end
end
