module PagesHelper
  def format_page_content(page)
    if page.dynamic
      simple_format ERB.new(page.content).result(binding)
    else
      simple_format page.content
    end
  end

  def page_permissions
    permissions = %w[user team]
    if current_user.person.manager?
      permissions << 'manager'
    end
    if current_user.person.admin?
      permissions.unshift 'public'
      permissions << 'admin'
    end
    permissions
  end
end
