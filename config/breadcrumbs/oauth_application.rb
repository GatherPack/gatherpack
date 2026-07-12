crumb :oauth_applications do
  link "OAuth Applications", oauth_applications_path
end

crumb :oauth_application do |oauth_application|
  link oauth_application.new_record? ? "New OAuth application" : oauth_application.identifier_name, oauth_application
  parent :oauth_applications
end
