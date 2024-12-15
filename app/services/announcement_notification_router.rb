class AnnouncementNotificationRouter
  def initialize(announcement)
    @announcement = announcement
    @people = announcement.team ? announcement.team.people : Person.all
  end

  def run
    @people.each do |person|
      next unless person.user

      AnnouncementMailer.with(announcement: @announcement, person: person).announcement.deliver_later
    end
  end
end