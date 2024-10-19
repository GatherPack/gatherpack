crumb :reports do
  link "Reports", reports_path
end

crumb :report do |report|
  link report.identifier_name, report
  parent :reports
end

crumb :run do |report|
  link "Run", report
  parent :report
end
