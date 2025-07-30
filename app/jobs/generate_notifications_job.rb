class GenerateNotificationsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    if Infodump.ready?
      User.all.each do |user|
        DeliverInfodumpJob.perform_later(user.person)
      end
    end
  end
end
