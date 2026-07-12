crumb :questions do
  link "Questions", questions_path
end

crumb :question do |question|
  link question.new_record? ? "New question" : question.title, question
  parent :questions
end
