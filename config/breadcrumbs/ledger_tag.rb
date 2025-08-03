crumb :ledger_tags do
  link "Ledger Tags", ledger_tags_path
  parent :setup
end

crumb :ledger_tag do |ledger_tag|
  link ledger_tag.new_record? ? "New ledger tag" : ledger_tag.identifier_name, ledger_tag
  parent :ledger_tags
end
