module RelationshipsHelper
  def relationship_as_badge(relationship, host)
    other = host == relationship.parent ? relationship.child : relationship.parent
    label = host == relationship.parent ? relationship.relationship_type.child_label : relationship.relationship_type.parent_label
    content = i('user') + ' ' + "#{other.display_name} [#{label}]"
    link_to other do
      tag.span content, class: 'badge text-bg-dark'
    end
  end
end
