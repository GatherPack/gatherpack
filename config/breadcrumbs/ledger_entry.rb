crumb :ledger_entry do |ledger_entry|
  link ledger_entry.identifier_name, ledger_ledger_entry_path(ledger_entry.ledger, ledger_entry)
  parent :ledger, ledger_entry.ledger
end
