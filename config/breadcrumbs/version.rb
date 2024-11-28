crumb :versions do
  link "Aduit Logs", audit_log_index_path
end

crumb :version do |version|
  link version.created_at, audit_log_path(version)
  parent :versions
end
