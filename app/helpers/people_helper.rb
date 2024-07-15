module PeopleHelper
  def get_avatar_url(avatar)
    avatar.attached? ? url_for(avatar) : asset_path("default_profile.png")
  end

  def get_joinable_teams(person, current_user)
    if current_user.admin?
      return Team.all
    end

    available_teams = person.teams + current_user.person.teams.where(join_permission: Team.join_permissions[:added_by_current_member])
    current_user.person.teams.where(join_permission: Team.join_permissions[:added_by_manager]).each do |t|
      if !t.managers.include?(current_user.person)
        available_teams.append t
      end
    end
    if !person.user.nil?
      available_teams += Team.all.where(join_permission: Team.join_permissions[:has_account])
    end

    available_teams
  end
end
