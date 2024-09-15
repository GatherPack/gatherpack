require "test_helper"
require "generators/breadcrumb/breadcrumb_generator"

class BreadcrumbGeneratorTest < Rails::Generators::TestCase
  tests BreadcrumbGenerator
  destination Rails.root.join("tmp/generators")
  setup :prepare_destination

  # test "generator runs without errors" do
  #   assert_nothing_raised do
  #     run_generator ["arguments"]
  #   end
  # end
end
