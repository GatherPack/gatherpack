module ApplicationHelper
  def contrasting_color(color)
    base = Color::RGB.by_hex(color)
    if base.brightness > 0.5
      '#000'
    else
      '#fff'
    end
  end

  def as_badge(obj)
    case obj
    when Badge
      badge_as_badge(obj)
    when Team
      team_as_badge(obj)
    end.html_safe
  end
end
