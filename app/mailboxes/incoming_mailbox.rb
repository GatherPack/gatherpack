class IncomingMailbox < ApplicationMailbox
  def process
    box = Mailbox.where(address: mail.header_fields.select { |x| x.name.downcase == 'x-original-to' }.first.value.split('@').first.split('+').first).first

    body_content = if mail.multipart?
      mail.text_part ? mail.text_part.decoded : mail.html_part&.decoded
    else
      mail.body.decoded
    end

    message = MailboxMessage.create(
      mailbox: box,
      from: mail.from,
      subject: mail.subject,
      body: body_content
    )

    mail.attachments.each do |attachment|
      message.attachments.attach(
        io: StringIO.new(attachment.decoded),
        filename: attachment.filename,
        content_type: attachment.content_type
      )
    end

  end
end
