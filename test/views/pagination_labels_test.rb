require "test_helper"

class PaginationLabelsTest < ActionView::TestCase
  include Kaminari::Helpers::HelperMethods
  test "the pager shows its arrows and ellipsis as characters, not escaped entities" do
    html = paginate(Kaminari.paginate_array((1..200).to_a).page(5).per(10), params: { controller: "badge_types", action: "index" })

    [ "« First", "‹ Prev", "Next ›", "Last »", "…" ].each do |label|
      assert_includes html, label
    end
    assert_no_match(/&amp;[a-z]+;/, html)
  end
end
