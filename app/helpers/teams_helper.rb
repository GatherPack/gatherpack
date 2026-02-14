module TeamsHelper
  def team_as_badge(team, **opts)
    content = if opts[:small]
      i(team.team_type.icon)
    else
      i(team.team_type.icon) + " " + team.name
    end
    tag.span content, class: "badge", style: "background-color: #{team.color}; color: #{contrasting_color(team.color)}"
  end
end
