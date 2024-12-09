crumb :accounts do
  link "Accounts", accounts_path
end

crumb :account do |account|
  link account.identifier_name, account
  parent :accounts
end