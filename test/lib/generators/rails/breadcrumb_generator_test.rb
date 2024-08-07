require "test_helper"
require "generators/rails/breadcrumb/breadcrumb_generator"

class Rails::BreadcrumbGeneratorTest < Rails::Generators::TestCase
  tests Rails::BreadcrumbGenerator
  destination Rails.root.join("tmp/generators")
  setup :prepare_destination

  # test "generator runs without errors" do
  #   assert_nothing_raised do
  #     run_generator ["arguments"]
  #   end
  # end
end
