# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

SHIRT_SIZE = [ "Youth S", "Youth M", "Youth L", "S", "M", "L", "XL", "XXL", "3XL", "4XL" ]

persons = []

10.times do
  first_name = Faker::Name.first_name
  last_name = Faker::Name.last_name
  persons << Person.create(first_name: first_name,
                           last_name: last_name,
                           gender: "#{first_name} #{last_name}",
                           shirt_size: SHIRT_SIZE.sample,
                           phone_number: Faker::PhoneNumber.cell_phone,
                           address: Faker::Address.full_address,
                           birthday: Faker::Date.birthday(min_age: 18, max_age: 65),
                           dietary_restrictions: Faker::Food.allergen,
                           display_name: Faker::Name.name)
end

pw = Spicy::Proton.pair
user_person = persons[0]
user = User.create(email: Faker::Internet.email(name: user_person.display_name, separators: "."),
                   password: pw,
                   person: user_person,
                   admin: true,
                   architect: true)
puts "Created Test User with the following credentials:\nemail: #{user.email}\npassword: #{pw}"
