crumb :mailboxes do
  link "Mailboxes", mailboxes_path
end

crumb :mailbox do |mailbox|
  link mailbox.identifier_name, mailbox
  parent :mailboxes
end