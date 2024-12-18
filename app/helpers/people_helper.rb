module PeopleHelper
  def get_avatar_url(avatar)
    avatar.attached? ? url_for(avatar) : asset_path('default_profile.png')
  end

  def get_joinable_teams(person, current_user)
    if current_user.admin?
      return Team.all.to_a
    end

    (
      Team.where(join_permission: Team.join_permissions[:has_account]).includes(:team_type).to_a +
      person.teams.includes(:team_type).to_a +
      current_user.person.managed_teams.includes(:team_type).to_a
    ).uniq.sort_by { |t| [t.team_type.name, t.name] }
  end

  def person_as_badge(person, opt = nil)
    content = i('user') + ' ' + person.identifier_name
    if opt.present? && opt
      link_to person, class: 'undecorated', 'data-turbo': false do
        tag.span content, class: 'badge text-bg-primary'
      end
    else
      link_to person, class: 'undecorated' do
        tag.span content, class: 'badge text-bg-primary'
      end
    end
  end
end
