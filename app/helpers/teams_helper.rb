module TeamsHelper
  def team_as_badge(team)
    content = i(team.team_type.icon) + ' ' + team.name
    tag.span content, class: 'badge', style: "background-color: #{team.color}; color: #{contrasting_color(team.color)}"
  end
end
