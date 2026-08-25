require "test_helper"
require "generators/policy/policy_generator"

class PolicyGeneratorTest < Rails::Generators::TestCase
  tests Policy::PolicyGenerator
  destination Rails.root.join("tmp/generators")
  setup :prepare_destination

  # test "generator runs without errors" do
  #   assert_nothing_raised do
  #     run_generator ["arguments"]
  #   end
  # end
end
