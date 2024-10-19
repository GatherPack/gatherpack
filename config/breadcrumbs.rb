crumb :root do
  link "Home", root_path
end

crumb :new do |type|
  link "New #{type}"
end
