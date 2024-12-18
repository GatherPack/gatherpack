crumb :time_clock_periods do
  link "Time Clock Periods", time_clock_periods_path
end

crumb :time_clock_period do |time_clock_period|
  link time_clock_period.identifier_name, time_clock_period
  parent :time_clock_periods
end