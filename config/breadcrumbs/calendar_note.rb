crumb :calendar_notes do
  link "Calendar Notes", calendar_notes_path
end

crumb :calendar_note do |calendar_note|
  link calendar_note.identifier_name + if calendar_note.noteable then " - " + calendar_note.noteable.identifier_name else "" end, calendar_note
  parent :calendar
end
