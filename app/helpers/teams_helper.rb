module TeamsHelper
  def team_as_badge(team)
    content = i(team.team_type.icon) + ' ' + team.name
    link_to team do
      tag.span content, class: 'badge', style: "background-color: #{team.color}; color: #{contrasting_color(team.color)}"
    end
  end
end
