class GenerateNotificationsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    infodump_day = Settings[:infodump_day]
    infodump_time = Settings[:infodump_time]

    if infodump_day.nil? || infodump_time.nil?
      current_day = Time.now.strftime("%A")
      current_time = Time.now.strftime("%H:%M")

      if current_day == infodump_day
        now_minutes = minutes_since_midnight(current_time)
        infodump_minutes = minutes_since_midnight(infodump_time)
        if (now_minutes - infodump_minutes) <= 5 && (now_minutes - infodump_minutes) >= 0
          User.all.each do |user|
            DeliverInfodumpJob.perform_later(user.person)
          end
        end
      end
    end
  end

  def minutes_since_midnight(time_str)
    h, m = time_str.split(":").map(&:to_i)
    h * 60 + m
  end
end
