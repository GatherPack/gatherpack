crumb :mailbox_message do |mailbox_message|
  link mailbox_message.identifier_name, mailbox_mailbox_message_path(mailbox_message.mailbox, mailbox_message)
  parent :mailbox, mailbox_message.mailbox
end