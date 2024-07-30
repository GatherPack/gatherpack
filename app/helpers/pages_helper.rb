module PagesHelper
  def format_page_content(page)
    if page.dynamic
      simple_format ERB.new(page.content).result(binding)
    else
      simple_format page.content
    end
  end
end
