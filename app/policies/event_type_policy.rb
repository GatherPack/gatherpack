class EventTypePolicy < AdminPolicy
  def destroy?
    record.events.empty?
  end
end
