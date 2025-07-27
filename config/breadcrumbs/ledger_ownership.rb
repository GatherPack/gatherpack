crumb :ledger_ownerships do |ledger|
  link "Ledger Ownerships", ledger_ownerships_path
  parent :ledger, ledger
end

crumb :ledger_ownership do |ledger_ownership|
  link ledger_ownership.identifier_name, ledger_ownership_path(ledger_ownership.ledger, ledger_ownership)
  parent :ledger_ownerships, ledger_ownership.ledger
end
