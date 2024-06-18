module BadgesHelper
  def badge_as_badge(badge)
    content = if badge.short =~ /^fa-/
      i(badge.short)
    else
      badge.short
    end
    tag.span content, class: 'badge', style: "background-color: #{badge.color}; color: #{contrasting_color(badge.color)}"
  end
end
