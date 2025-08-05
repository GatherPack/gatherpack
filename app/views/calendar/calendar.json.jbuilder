json.array! @events do |event|
  background_color = event.team&.color || "#3788d8"
  json.id event.id
  json.title event.name
  json.allDay false
  json.start event.start_time
  json.end event.end_time
  json.url event_url(event)
  json.backgroundColor background_color
  json.textColor Color::RGB.by_hex(background_color).brightness > 0.5 ? "#6d6753" : "#fffdf6"

  json.extendedProps do
    json.icon "fa-" + (event.team&.team_type&.icon || "star")
  end
end if @events

json.array! @birthdays do |person|
  json.id person.id
  json.title "#{person.identifier_name}'s Birthday"
  json.allDay true
  json.start person.birthday.change(year: (person.birthday.yday - @start_time_doy < 0 ? @end_time_year : @start_time_year))
  json.end nil
  json.url person_url(person)
  json.backgroundColor "#3788d8"
  json.textColor "#fffdf6"

  json.extendedProps do
    json.icon "fa-cake-candles"
  end
end if @birthdays

json.array! @notes do |note|
  json.id note.id
  json.title note.identifier_name
  json.allDay note.end_time.nil?
  json.start note.start_time
  json.end note.end_time
  json.url calendar_note_url(note)
  json.backgroundColor "#efad03"
  json.textColor "#6d6753"

  json.extendedProps do
    json.icon "fa-note-sticky"
  end
end if @notes

json.array! @punches do |punch|
  title = "#{punch&.time_clock_period&.name || ""} Clock Punch"
  title.prepend(punch.hours.to_s, "-hour ") if punch.hours

  json.id punch.id
  json.title title
  json.allDay punch.end_time.nil?
  json.start punch.start_time
  json.end punch.end_time
  json.backgroundColor "#6d6753"
  json.textColor "#fffdf6"

  json.extendedProps do
    json.icon "fa-hourglass-half"
  end
end if @punches
