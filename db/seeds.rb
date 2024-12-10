# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

team_type = TeamType.find_or_create_by!(name: "Test Team Type", icon: "address-book")
event_type = EventType.find_or_create_by!(name: "Test Event Type")
badge_type = BadgeType.find_or_create_by!(name: "Test Badge Type")
users = []
persons = []

10.times do |time|
  persons << Person.find_or_create_by!(first_name: "Test First Name #{time}",
                                     last_name: "Test Last Name #{time}",
                                     display_name: "Test Display Name #{time}",
                                     gender: "Test Gender #{time}",
                                     shirt_size: "Test Shirt Size#{time}",
                                     phone_number: "Test Phone Number#{time}",
                                     address: "Test Address#{time}",
                                     birthday: "1991-11-11",
                                     dietary_restrictions: "Test Dietary Restrictions#{time}")
end

team = Team.find_or_create_by!(name: "Test Team", color: "#f5c211", team_type: team_type, join_permission: "added_by_admin")
badge = Badge.find_or_create_by!(name: "Test Badge", color: "#2ec27e", short: "anchor", badge_type: badge_type, team: team)
token = Token.find_or_create_by!(value: "Test Token") do |token|
  token.tokenable = persons[0]
end
event = Event.find_or_create_by!(name: "Test Event",
                                 description: "Test Event Description",
                                 start_time: "1991-11-11 11:11:00",
                                 end_time: "1991-11-11 23:11:00",
                                 location: "Test Location",
                                 event_type: event_type,
                                 team: team)
announcement = Announcement.find_or_create_by!(title: "Test Announcement",
                                               content: "Test Announcement Content",
                                               start_time: "1991-11-11 11:11:00",
                                               end_time: "1991-11-11 23:11:00",
                                               team: team)
page = Page.find_or_create_by!(title: "Test Page",
                               content: "Test Page Content",
                               viewer: "user",
                               editor: "manager",
                               dynamic: false,
                               team: team)
variable = Variable.find_or_create_by!(name: "test_variable",
                                       klass: "string",
                                       raw_value: "\"Test String Variable Content\"")
report = Report.find_or_create_by!(name: "Test Report",
                                   code: "\"Test Report Content\"")
hook = Hook.find_or_create_by!(name: "Test Hook",
                               event: "announcement - update",
                               code: "\"Test Hook Content\"")
5.times do |time|
  badge_assignment = BadgeAssignment.find_or_create_by!(person: persons[time * 2], badge: badge)
  membership = Membership.find_or_create_by!(team: team, person: persons[time * 2], manager: false)
end
