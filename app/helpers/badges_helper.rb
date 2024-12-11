module BadgesHelper
  def badge_as_badge(badge)
    link_to badge, class: 'undecorated' do
      tag.span badge.short, class: 'badge', style: "background-color: #{badge.color}; color: #{contrasting_color(badge.color)}"
    end
  end
end
