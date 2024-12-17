class AnnouncementMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notification_mailer.announcement.subject
  #
  def announcement
    @announcement = params[:announcement]
    @person = params[:person]

    mail(
      subject: "Announcement Posted | #{Settings[:title]}",
      to: @person.user.email,
      track_opens: 'true',
      message_stream: 'outbound')
  end
end
