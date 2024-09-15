crumb :tokens do
  link 'Tokens', tokens_path
end

crumb :token do |token|
  link token.identifier_name, token
  parent :tokens
end
