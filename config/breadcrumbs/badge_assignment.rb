crumb :badge_assignments do |badge|
  link "Badge Assignments", badge_badge_assignments_path(badge)
  parent :badge, badge
end

crumb :badge_assignment do |badge_assignment|
  link badge_assignment.new_record? ? "New badge assignment" : [ badge_assignment.identifier_name, badge_badge_assignment_path(badge_assignment.badge, badge_assignment) ]
  parent :badge_assignments, badge_assignment.badge
end
