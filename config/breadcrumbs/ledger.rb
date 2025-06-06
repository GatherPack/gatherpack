crumb :ledgers do
  link "Ledgers", ledgers_path
end

crumb :ledger do |ledger|
  link ledger.identifier_name, ledger
  parent :ledgers
end