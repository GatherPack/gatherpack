crumb :announcements do
  link "Announcements", announcements_path
end

crumb :announcement do |announcement|
  link announcement.new_record? ? "New announcement" : announcement.identifier_name, announcement
  parent :announcements
end
