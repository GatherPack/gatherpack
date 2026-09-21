require "test_helper"

# Every model behind a search page must allowlist attributes for Ransack.
# Without it `.ransack` raises and the index 500s, which is how eight of these
# pages were failing.
class RansackableTest < ActiveSupport::TestCase
  SEARCHED_MODELS = [
    Announcement, AuditLog, BadgeAssignment, BadgeType, Badge, BudgetPeriod,
    Budget, CalendarNote, Checkin, EventType, Event, Hook, LedgerEntryLink,
    LedgerOwnership, LedgerTag, Ledger, Mailbox, MailboxMessage, Membership,
    Page, Person, Question, RelationshipType, Report,
    Shortcut, TeamType, Team, TimeClockPeriod, TimeClockPunch, Token, Variable
  ].freeze

  test "every searched model allowlists ransackable attributes" do
    broken = SEARCHED_MODELS.reject do |model|
      model.ransackable_attributes
      true
    rescue StandardError
      false
    end
    assert_empty broken, "these models do not allowlist ransackable attributes: #{broken.inspect}"
  end

  test "every searched model can be ransacked and sorted" do
    broken = SEARCHED_MODELS.filter_map do |model|
      q = model.ransack({})
      q.sorts = "updated_at asc" if model.column_names.include?("updated_at")
      q.result.limit(1).to_a
      nil
    rescue StandardError => e
      "#{model}: #{e.class}"
    end
    assert_empty broken, "these models cannot be ransacked: #{broken.inspect}"
  end
end
