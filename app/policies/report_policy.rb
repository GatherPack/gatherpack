class ReportPolicy < AdminPolicy
  # Running a report evaluates its stored code, so it is gated the same way
  # viewing one is. Authoring stays architect-only via create?/update?.
  def run?
    show?
  end

  def create?
    user&.architect?
  end

  def update?
    user&.architect?
  end
end
