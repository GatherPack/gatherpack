crumb :ledger_entry_links do
  link "Ledger_entry_links", ledger_entry_links_path
end

crumb :ledger_entry_link do |ledger_entry_link|
  link ledger_entry_link.identifier_name, ledger_entry_link
  parent :ledger_entry_links
end