class AnnouncementNotificationRouter
  def initialize(announcement)
    @announcement = announcement
    @people = announcement.team ? announcement.team.people : Person.all
  end

  def run
    return unless @announcement.notify_now
    subject = "#{Settings[:title]} - #{@announcement.title}"
    content = ""
    content << "<h1>Announcement Posted in #{@announcement.team.name}</h1>"
    content << "<h2>#{@announcement.title}</h2><div>#{@announcement.content}</div>"
    @people.each do |person|
      next unless person.user
      next unless person.user.email.present?
      SendEmailJob.perform_later(Gateway[:email_sending], person.user.email, subject, content)
    end
  end
end
