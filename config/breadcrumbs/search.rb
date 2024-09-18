crumb :search do |keyword|
  link "Search for \"#{keyword}\"", search_path(q: keyword)
end
