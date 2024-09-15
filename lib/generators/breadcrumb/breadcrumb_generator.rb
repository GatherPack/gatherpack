module Breadcrumb
  class BreadcrumbGenerator < Rails::Generators::NamedBase
    source_root File.expand_path("templates", __dir__)

    def create_breadcrumb
      template "breadcrumb.rb", File.join("config/breadcrumbs", class_path, "#{file_name}.rb")
    end
  end
end
