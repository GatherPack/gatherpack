module BadgesHelper
  def badge_as_badge(badge)
    link_to badge, class: "undecorated" do
      tag.span i(badge.short), class: "badge", style: "background-color: #{badge.color}; color: #{contrasting_color(badge.color)}", title: badge.identifier_name
    end
  end
end
