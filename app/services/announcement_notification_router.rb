class AnnouncementNotificationRouter
  def initialize(announcement)
    @announcement = announcement
    @people = announcement.team ? announcement.team.all_people : Person.all
  end

  def run
    return if @announcement.notify_now.blank? || @announcement.notify_now == "0"
    md = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, no_intra_emphasis: true, fenced_code_blocks: true, lax_spacing: true)

    subject = "#{Settings[:title]} - #{@announcement.title}"
    content = ""
    content << "<h1>Announcement Posted in #{@announcement&.team&.name || Settings[:title]}</h1>"
    content << "<h2>#{@announcement.title}</h2><div>#{md.render(@announcement.content)}</div>"
    @people.each do |person|
      next unless person.user
      next unless person.user.email.present?
      SendEmailJob.perform_later(Gateway[:email_sending], person.user.email, subject, content)
    end
  end
end
