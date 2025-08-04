crumb :ledgers do
  link "Ledgers", ledgers_path
end

crumb :ledger do |ledger|
  link ledger.new_record? ? "New ledger" : ledger.identifier_name, ledger
  parent :ledgers
end

crumb :ledger_transfer do
  link "New ledger transfer"
  parent :ledgers
end
