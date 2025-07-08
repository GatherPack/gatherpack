module MembershipsHelper
  def membership_as_badge(membership)
    content = i(membership.manager ? "user-tie" : "user") + " " + membership.team.name
    link_to [ membership.team, membership ] do
      tag.span content, class: "badge", style: "background-color: #{membership.team.color}; color: #{contrasting_color(membership.team.color)}"
    end
  end
end
