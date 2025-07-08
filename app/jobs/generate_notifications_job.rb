class GenerateNotificationsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    infodump_day = Settings[:infodump_day]
    infodump_time = Settings[:infodump_time]

    # if they are not set, do nothing
    if infodump_day.nil? || infodump_time.nil?
      current_day = Time.now.strftime("%A")
      current_time = Time.now.strftime("%H:%M")

      # if the current day and time match the infodump day and time, send notifications
      if current_day == infodump_day && (current_time >= (infodump_time.to_i - 5))
        User.all.each do |user|
          DeliverInfodumpJob.perform_later(user.person)
        end
      end
    end
  end
end
