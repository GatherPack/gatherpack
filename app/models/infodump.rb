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
        if (now_minutes - infodump_minutes) <= 5 && (now_minutes - infodump_minutes) >= 0
          return true
        else
          puts "Infodump is scheduled for #{infodump_day} at #{infodump_time}, but it is #{current_day} at #{current_time}."
        end
      else
        puts "Infodump is scheduled for #{infodump_day}, but it is #{current_day}."
      end
    else
      puts "Infodump day or time not set in settings."
    end
    false
  end

  def initialize(person)
    @person = person
  end

  def generate
    @deliverable = false
    @announcements = {}
    @person.teams.each do |team|
      @announcements[team] = team.announcements.visible.order(created_at: :desc)
    end

    @content = ""
    @content << "<h1>Weekly #{Settings[:title]} Updates for #{@person.display_name}</h1>"
    @announcements.each do |team, announcements|
      next if announcements.empty?
      @deliverable = true

      @content << "<h2>#{team.name} Announcements</h2>"
      announcements.each do |announcement|
        @content << "<h3>#{announcement.title}</h3><div>#{announcement.content}</div>"
      end
    end
  end

  def send
    SendEmailJob.perform_later(Gateway[:email_sending], @person.user.email, "Your #{Settings[:title]} Announcements", @content) if @deliverable
  end
end
