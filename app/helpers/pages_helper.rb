module PagesHelper
  def format_page_content(page)
    if page.dynamic
      begin
        ERB.new(page.content).result(binding).html_safe
      rescue SyntaxError => e
        "<pre>Syntax error in page content: \n#{e.message}\n</pre>".html_safe
      end
    else
      simple_format page.content
    end
  end

  def page_permissions
    permissions = %w[user team]
    if current_user.person.manager?
      permissions << "manager"
    end
    if current_user.person.admin?
      permissions.unshift "public"
      permissions << "admin"
    end
    permissions
  end
end
