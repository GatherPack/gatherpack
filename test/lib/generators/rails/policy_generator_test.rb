require "test_helper"
require "generators/rails/policy/policy_generator"

class Rails::PolicyGeneratorTest < Rails::Generators::TestCase
  tests Rails::PolicyGenerator
  destination Rails.root.join("tmp/generators")
  setup :prepare_destination

  # test "generator runs without errors" do
  #   assert_nothing_raised do
  #     run_generator ["arguments"]
  #   end
  # end
end
