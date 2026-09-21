# Generates a realistic development dataset.
#
# db/seeds.rb already exists, but it is deliberately minimal and idempotent
# (it runs in every environment via db:setup) and its records are all named
# "Test Something 0..9" on a single flat team. That is fine as a smoke test but
# useless for exercising search, filtering, sorting, pagination or the team
# hierarchy - every name shares a prefix and there is no tree to walk.
#
#   bin/rails sample_data:load          # add sample data
#   bin/rails sample_data:load[200]     # ...with 200 people
#   bin/rails sample_data:reset         # wipe previously generated data first
#
# Everything it creates is tagged so sample_data:reset can find it again
# without touching records you made by hand.
namespace :sample_data do
  TAG = "[sample]".freeze

  FIRST_NAMES = %w[
    Ada Amir Aisha Bex Bruno Camila Chen Dara Diego Elena Emeka Farah Felix
    Grace Hana Ibrahim Imani Jack Jian Jonas Kavya Kofi Lars Leila Lucia Marco
    Maya Nadia Nikhil Nora Omar Priya Quinn Rafael Rin Rosa Sam Sofia Tariq
    Thandi Uma Viktor Wren Xiulan Yosef Zara Aoife Bodhi Clara Desmond
  ].freeze

  LAST_NAMES = %w[
    Abara Alvarez Bakker Bianchi Chen Costa Dubois Eriksen Farooq Fitzgerald
    Gagnon Ghosh Haddad Halvorsen Ibrahim Iwu Jansen Kowalski Kimura Lindqvist
    Moreau Mwangi Nakamura Novak Okafor Olsen Petrov Quintana Rossi Ruiz
    Santos Silva Takahashi Tanaka Ueda Vargas Virtanen Wagner Wu Yamamoto
    Zhang Doherty Nakagawa Oyelaran Bergstrom Castellanos Dragomir Haugen
  ].freeze

  SHIRT_SIZES = %w[XS S M L XL XXL].freeze

  desc "Load realistic sample data (dev only). Usage: sample_data:load[people_count]"
  task :load, [ :people_count ] => :environment do |_t, args|
    guard_environment!
    count = (args[:people_count] || 60).to_i

    # A fixed seed keeps runs reproducible, so a bug you find is a bug you can
    # find again.
    rng = Random.new(20_260_829)

    # Clear first so a second run replaces the set rather than stacking a
    # duplicate on top of it.
    remove_sample_data(announce: false)

    puts "Generating sample data (#{count} people)..."

    team_types = %w[Subteam Committee Mentor\ Group Cohort].map do |name|
      TeamType.find_or_create_by!(name: "#{name} #{TAG}") { |t| t.icon = "people-group" }
    end

    # A real tree, so the policy scope and the Teams filters have something to
    # actually traverse.
    root = make_team("Golden Gate Robotics", team_types[0], nil, "#8a6d3b")
    build = make_team("Build", team_types[0], root, "#31708f")
    software = make_team("Software", team_types[0], build, "#3c763d")
    mechanical = make_team("Mechanical", team_types[0], build, "#a94442")
    electrical = make_team("Electrical", team_types[0], build, "#8a6d3b")
    business = make_team("Business", team_types[1], root, "#663c9e")
    outreach = make_team("Outreach", team_types[1], business, "#2c7873")
    scouting = make_team("Scouting", team_types[3], root, "#b5651d")
    leaf_teams = [ software, mechanical, electrical, outreach, scouting ]

    people = Array.new(count) do |i|
      first = FIRST_NAMES[rng.rand(FIRST_NAMES.size)]
      last  = LAST_NAMES[rng.rand(LAST_NAMES.size)]
      Person.create!(
        first_name: first,
        last_name: last,
        display_name: "#{first} #{last}",
        gender: [ "female", "male", "non-binary", nil ][rng.rand(4)],
        shirt_size: SHIRT_SIZES[rng.rand(SHIRT_SIZES.size)],
        phone_number: "555-01#{format('%02d', rng.rand(100))}",
        address: "#{rng.rand(1..999)} Example St, San Francisco, CA",
        birthday: Date.new(rng.rand(2004..2010), rng.rand(1..12), rng.rand(1..28)),
        dietary_restrictions: [ nil, nil, nil, "vegetarian", "vegan", "no nuts" ][rng.rand(6)],
        bio: "#{TAG} Sample team member."
      )
    end

    people.each_with_index do |person, i|
      team = leaf_teams[i % leaf_teams.size]
      Membership.find_or_create_by!(person: person, team: team) do |m|
        m.manager = (i % 12).zero?   # roughly one manager per dozen
      end
      # A slice of people sit on a second team, so the tree is not a clean
      # partition - that is what makes the policy scope interesting.
      Membership.find_or_create_by!(person: person, team: scouting) if (i % 7).zero?
    end

    # Each login needs its OWN person: people[0] is also the first manager, so
    # picking "the first manager" for manager@example.com used to steal the
    # person already assigned to admin@example.com and leave admin with none.
    taken = []
    admin_person   = people[0]
    manager_person = people.find { |p| p != admin_person && p.memberships.any?(&:manager) } || people[1]
    member_person  = (people - [ admin_person, manager_person ]).first
    taken = [ admin_person, manager_person, member_person ]
    raise "not enough people for the sample logins" if taken.uniq.size < 3

    admin = make_login("admin@example.com", admin_person, admin: true)
    make_login("manager@example.com", manager_person)
    make_login("member@example.com", member_person)

    # Put everyone who already had a login onto the root team, as a manager.
    #
    # Without this the task builds a team tree the operator is not part of, and
    # this app only shows you people who share a team with you - so you would
    # load 60 people and still see nobody.
    #
    # Manager rather than plain member because the two policies walk the tree
    # differently: PersonPolicy expands a visible team down through all its
    # descendants, but Person#all_team_ids only walks downwards from teams you
    # MANAGE. A plain membership on root would therefore show all 60 people
    # and still only one team. Sample teams are destroyed on reset, which takes
    # these memberships with them.
    adopted = Person.joins(:user).where.not(id: people.map(&:id)).distinct.to_a
    adopted.each do |person|
      Membership.find_or_create_by!(person: person, team: root) { |m| m.manager = true }
      # Also a couple of leaf teams, so the Teams page's default "My Teams"
      # view has something in it rather than just the root.
      [ software, outreach ].each do |team|
        Membership.find_or_create_by!(person: person, team: team)
      end
    end

    event_type = EventType.find_or_create_by!(name: "Meeting #{TAG}")
    comp_type  = EventType.find_or_create_by!(name: "Competition #{TAG}")
    [
      [ "Build Season Kickoff", "Shop",          comp_type,  root ],
      [ "Weekly Build Meeting", "Shop",          event_type, build ],
      [ "Software Standup",     "Lab",           event_type, software ],
      [ "CAD Review",           "Lab",           event_type, mechanical ],
      [ "Wiring Workshop",      "Shop",          event_type, electrical ],
      [ "Outreach Planning",    "Library",       event_type, outreach ],
      [ "Scouting Training",    "Library",       event_type, scouting ],
      [ "Regional Competition", "Convention Ctr", comp_type, root ]
    ].each_with_index do |(name, location, type, team), i|
      Event.find_or_create_by!(name: "#{name} #{TAG}") do |e|
        e.description = "#{TAG} Sample event."
        e.location = location
        e.event_type = type
        e.team = team
        e.start_time = i.days.from_now.change(hour: 16)
        e.end_time = i.days.from_now.change(hour: 19)
      end
    end

    # A mix of open and closed, so the Questions status filter has something to
    # actually switch between.
    [
      [ "How do I wire the new encoder?", software, false ],
      [ "What is the CAD review process?", mechanical, false ],
      [ "Where do we store the spare batteries?", build, true ],
      [ "Who is running outreach at the regional?", outreach, false ],
      [ "Is the pit checklist finalised?", root, true ],
      [ "Which laptop has the scouting app?", scouting, true ]
    ].each_with_index do |(title, team, closed), i|
      question = Question.find_or_create_by!(title: "#{title} #{TAG}") do |q|
        q.content = "#{TAG} Sample question."
        q.team = team
        q.person = people[i % people.size]
        q.closed = closed
      end
      rng.rand(0..3).times do |r|
        Reply.find_or_create_by!(question: question, content: "#{TAG} Sample reply #{r}.") do |reply|
          reply.person = people[(i + r + 1) % people.size]
        end
      end
    end

    puts "Done."
    puts "  #{count} people across #{Team.where('name LIKE ?', "%#{TAG}%").count} teams"
    if adopted.any?
      puts "  Added #{adopted.size} existing account(s) as managers of #{root.name} so they can see it all:"
      adopted.each { |person| puts "    #{person.display_name} <#{person.user.email}>" }
    end
    puts "  Log in as #{admin.email} / password123 (admin)"
    puts "  Also: manager@example.com, member@example.com (same password)"
  end

  desc "Delete everything sample_data:load created"
  task reset: :environment do
    guard_environment!
    remove_sample_data
  end

  # --- helpers -------------------------------------------------------------

  def remove_sample_data(announce: true)
    like = "%#{TAG}%"

    questions = Question.where("title LIKE ?", like)
    Reply.where(question_id: questions.select(:id)).destroy_all
    Reply.where("content LIKE ?", like).destroy_all
    questions.destroy_all

    # Anything you created while signed in as a sample login, or attached to a
    # sample team, still points at these. Destroying them would take your own
    # records with it, so keep those and report which.
    kept = []
    kept += destroy_each(Person.where("bio LIKE ?", like)) { |person| person.user&.destroy! }
    kept += destroy_each(Event.where("name LIKE ?", like))
    kept += destroy_each(Team.where("name LIKE ?", like).order(Arel.sql("parent_id IS NULL")))
    kept += destroy_each(EventType.where("name LIKE ?", like))
    kept += destroy_each(TeamType.where("name LIKE ?", like))

    return unless announce

    puts "Sample data removed."
    return if kept.empty?

    puts "  Kept #{kept.size} record(s) your own data still references:"
    kept.each { |record| puts "    #{record.class}: #{record.try(:identifier_name) || record.try(:name) || record.id}" }
  end

  # Destroys what it can, skipping records something outside the sample set
  # still references. Returns the ones it had to keep.
  def destroy_each(scope)
    kept = []
    scope.find_each do |record|
      record.destroy!
      yield record if block_given?
    rescue ActiveRecord::InvalidForeignKey, ActiveRecord::DeleteRestrictionError
      kept << record
    end
    kept
  end

  def guard_environment!
    return unless Rails.env.production?

    abort "sample_data tasks refuse to run in production."
  end

  def make_team(name, team_type, parent, color)
    Team.find_or_create_by!(name: "#{name} #{TAG}") do |t|
      t.team_type = team_type
      t.parent = parent
      t.color = color
      t.join_permission = "added_by_manager"
    end
  end

  def make_login(email, person, admin: false)
    user = User.find_or_initialize_by(email: email)
    user.password = "password123" if user.new_record?
    user.admin = admin
    user.save!
    person.update!(user: user)
    user
  end
end
