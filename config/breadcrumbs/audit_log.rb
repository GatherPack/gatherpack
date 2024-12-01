crumb :audit_logs do
  link "Audit Log", audit_logs_path
end

crumb :audit_log do |log|
  link log.created_at, log
  parent :audit_logs
end
