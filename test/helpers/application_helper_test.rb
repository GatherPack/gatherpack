require "test_helper"

class ApplicationHelperTest < ActionView::TestCase
  test "contrasting_color picks text color by brightness" do
    assert_equal "#000", contrasting_color("#ffffff")
    assert_equal "#fff", contrasting_color("#000000")
    assert_equal "#6d6753", contrasting_color("#34c233", dark: "#6d6753", light: "#fffdf6")
  end

  test "contrasting_color falls back instead of raising on blank or non-hex colors" do
    [ nil, "", "  ", "red", "#zzz" ].each do |color|
      assert_equal "#000", contrasting_color(color), "for #{color.inspect}"
    end
  end

  test "event_calendar_colors uses the team color" do
    colors = event_calendar_colors(Event.new(team: Team.new(color: "#000000")))
    assert_equal({ background: "#000000", text: "#fffdf6" }, colors)
  end

  test "event_calendar_colors falls back to the default for missing or invalid colors" do
    [ Event.new, Event.new(team: Team.new(color: nil)), Event.new(team: Team.new(color: "red")) ].each do |event|
      assert_equal ApplicationHelper::DEFAULT_EVENT_COLOR, event_calendar_colors(event)[:background]
    end
  end
end
