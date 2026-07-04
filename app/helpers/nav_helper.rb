module NavHelper
  def nav_link(link, path, icon, method: "get")
    data = {}
    if method != "get"
      data["turbo-method"] = method
    end
    tag.div class: "nav-item" do
      link_to path, class: active_status(path), data: data do
        icon_text(icon, link)
      end
    end
  end

  def nav_heading(label)
    tag.h6 label, class: "nav-item"
  end

  def resolve_nav_path(item)
    case item.path
    when Symbol then send(item.path)
    when Proc then instance_exec(&item.path)
    else item.path
    end
  end

  def setup_item_visible?(item)
    return true if item.policy_check.nil?
    item.policy_check.call(self)
  end

  private

  def active_status(path)
    "active" if (path == "/" && request.path == "/") ||
      (path != "/" && request.path.starts_with?(path)) ||

      (path == "/calendar" && request.path.starts_with?("/events")) ||
      (path == "/time_clock_punches" && request.path.starts_with?("/time_clock")) ||
      (path == "/ledgers" && request.path.starts_with?("/ledger")) ||

      (path == "/setup" && request.path.starts_with?("/team_types")) ||
      (path == "/setup" && request.path.starts_with?("/badge_types")) ||
      (path == "/setup" && request.path.starts_with?("/event_types")) ||
      (path == "/setup" && request.path.starts_with?("/relationship_types")) ||
      (path == "/setup" && request.path.starts_with?("/checkin_fields")) ||
      (path == "/setup" && request.path.starts_with?("/ledger_tags")) ||
      (path == "/setup" && request.path.starts_with?("/gateways"))
  end
end
