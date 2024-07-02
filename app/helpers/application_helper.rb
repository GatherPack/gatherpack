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

  def flash_to_class(type)
    case type
    when 'notice'
      bootstrap_type = 'info';
    else
      bootstrap_type = type;
    end

    "alert-" + bootstrap_type
  end
  def flash_to_icon(type)
    case type
    when 'success'
      bootstrap_icon = '#check-circle-fill'
    when 'warning', 'danger'
      bootstrap_icon = '#exclamation-triangle-fill'
    else
      bootstrap_icon = '#info-fill'
    end

    bootstrap_icon
  end
end
