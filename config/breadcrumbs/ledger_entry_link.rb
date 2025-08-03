crumb :ledger_entry_links do
  link "Ledger Entry Links", ledger_entry_links_path
end

crumb :ledger_entry_link do |ledger_entry_link|
  link ledger_entry_link.new_record? ? "New ledger entry link" : ledger_entry_link.identifier_name, ledger_entry_link
  parent :ledger_entry_links
end
