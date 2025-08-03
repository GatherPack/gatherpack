crumb :time_clock_punches do
  link "Time Clock", time_clock_punches_path
end

crumb :time_clock_punch do |time_clock_punch|
  link time_clock_punch.new_record? ? "New time clock punch" : time_clock_punch.identifier_name, time_clock_punch
  parent :time_clock_punches
end
