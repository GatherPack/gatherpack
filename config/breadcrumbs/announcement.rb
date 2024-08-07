crumb :announcements do
  link "Announcements", announcements_path
end

crumb :announcement do |announcement|
  link announcement.identifier_name, announcement
  parent :announcements
end