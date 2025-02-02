crumb :pages do
  link "Pages", pages_path
end

crumb :page do |page|
  link page.identifier_name, page
  parent :pages
end
