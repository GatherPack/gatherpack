module RelationshipsHelper
  def relationship_as_badge(relationship, **opts)
    other = opts[:host] == relationship.parent ? relationship.child : relationship.parent
    label = opts[:host] == relationship.parent ? relationship.relationship_type.child_label : relationship.relationship_type.parent_label
    content = i("user") + " " + "#{other.display_name} [#{label}]"
    if policy(other).show?
      link_to other do
        tag.span content, class: "badge text-bg-dark"
      end
    else
      tag.span content, class: "badge text-bg-dark", title: "You don't have permission to view this person."
    end
  end
end
