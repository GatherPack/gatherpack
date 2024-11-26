module BadgesHelper
  def badge_as_badge(badge)
    tag.span badge.short, class: 'badge', style: "background-color: #{badge.color}; color: #{contrasting_color(badge.color)}", title: badge.name
  end
end
