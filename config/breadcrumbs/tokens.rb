crumb :tokens do
  link 'Tokens', tokens_path
end

crumb :token do |token|
  link token.new_record? ? "New token" : token.identifier_name, token
  parent :tokens
end
