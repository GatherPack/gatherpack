crumb :ledger_tags do
  link "Ledger_tags", ledger_tags_path
end

crumb :ledger_tag do |ledger_tag|
  link ledger_tag.identifier_name, ledger_tag
  parent :ledger_tags
end