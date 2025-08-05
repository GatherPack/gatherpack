class Infodump
  def self.minutes_since_midnight(time_str)
    h, m = time_str.split(":").map(&:to_i)
    h * 60 + m
  end

  def self.ready?
    infodump_day = Settings[:infodump_day]
    infodump_time = Settings[:infodump_time]

    if infodump_day.present? && infodump_time.present?
      current_day = Time.current.in_time_zone(Settings[:time_zone]).strftime("%A")
      current_time = Time.current.in_time_zone(Settings[:time_zone]).strftime("%H:%M")

      if current_day == infodump_day
        now_minutes = minutes_since_midnight(current_time)
        infodump_minutes = minutes_since_midnight(infodump_time)
        if (now_minutes - infodump_minutes) <= 4 && (now_minutes - infodump_minutes) >= 0
          return true
        end
      end
    end
    false
  end

  def initialize(person)
    @person = person
  end

  def generate
    @deliverable = false
    @announcements = []
    @person.all_teams.each do |team|
      team.announcements.visible.each do |announcement|
        @announcements << announcement
      end
    end
    Announcement.visible.where(team_id: nil).or(Announcement.visible.where(team_id: "")).each do |announcement|
      @announcements << announcement
    end

    @announcements.sort_by! { |a| [ a.start_time.to_date, a.end_time.to_date ]  }

    @content = ""
    @content << "<h1>#{Date.today.strftime("%B %d")} Updates for #{@person.display_name}</h1>"
    @announcements.each do |announcement|
      if announcement
        @deliverable = true

        @content << "<h2>#{announcement.title}</h2><div>#{announcement.content}</div>"
      end
    end
  end

  def send
    SendEmailJob.perform_later(Gateway[:email_sending], @person.user.email, "Your #{Settings[:title]} Announcements", @content) if @deliverable
  end
end
