class Infodump
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
