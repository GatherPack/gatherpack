module Rails
  module Generators
    class PolicyGenerator < ::Rails::Generators::NamedBase
      source_root File.expand_path("templates", __dir__)

      def create_policy
        template "policy.rb", File.join("app/policies", class_path, "#{file_name}_policy.rb")
      end

      hook_for :test_framework
    end
  end
<<<<<<< HEAD
end
=======
end
>>>>>>> 9a156e3 (8 add pundit and some basic policies)
