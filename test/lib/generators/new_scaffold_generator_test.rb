require "test_helper"
require "generators/new_scaffold/new_scaffold_generator"

class NewScaffoldGeneratorTest < Rails::Generators::TestCase
  tests NewScaffoldGenerator
  destination Rails.root.join("tmp/generators")
  setup :prepare_destination

  # test "generator runs without errors" do
  #   assert_nothing_raised do
  #     run_generator ["arguments"]
  #   end
  # end
end
