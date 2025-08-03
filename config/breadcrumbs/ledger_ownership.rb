crumb :ledger_ownerships do |ledger|
  link "Ledger Ownerships", ledger_ownerships_path
  parent :ledger, ledger
end

crumb :ledger_ownership do |ledger_ownership|
  link ledger_ownership.new_record? ? "New ledger ownership" : ledger_ownership.identifier_name
  parent :ledger_ownerships, ledger_ownership.ledger
end
