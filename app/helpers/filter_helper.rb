module FilterHelper
  # Builds the removable "chip" data for the filters currently applied.
  #
  # `filters` is the same array of filter definitions the page passes to the
  # shared/_filter_bar partial, so the chip can reuse the declared :label and
  # :collection. That matters for *_id_eq filters: without the collection we
  # would render a raw UUID instead of "Team Type: Subteam".
  def active_filter_chips(q, filters)
    Array(filters).filter_map do |filter|
      if filter[:param]
        # Not a Ransack condition (Teams' My/All, Memberships' type).
        value = params[filter[:param]]
        field = filter[:param].to_s
      else
        value = q.public_send(filter[:attr])
        field = "q[#{filter[:attr]}]"
      end
      next unless filter_applied?(filter, value)

      { field: field, label: filter[:label], value: filter_chip_value(filter, value) }
    end
  end

  # With a declared default, "applied" means "differs from that default" -
  # blank is then a real choice (Questions' "All" against a default of "Open").
  # Without one, blank simply means unset.
  def filter_applied?(filter, value)
    return value.to_s != filter[:default].to_s if filter.key?(:default)

    value.present?
  end

  # True when the user has actually narrowed the list, which is what decides
  # whether we bother rendering the "Clear" affordance.
  def any_filters_applied?(q, extra_params = [])
    q.conditions.any? { |condition| condition.values.any? { |v| v.value.present? } } ||
      Array(extra_params).any? { |key| params[key].present? }
  end

  # Value a select should carry to mean "no filter", so the client can tell a
  # default apart from a choice.
  def filter_default_value(filter)
    filter[:default].to_s if filter.key?(:default)
  end

  # Human label for the sort control, e.g. "Last Name ↑". `sorts` is the
  # attribute => label hash the page already passes for the dropdown items.
  def current_sort_label(q, sorts)
    sort = q.sorts.first
    return "Sort" if sort.blank?

    name = sorts[sort.name.to_sym] || sort.name.humanize
    "#{name} #{sort.dir == 'desc' ? '↓' : '↑'}"
  end

  private

  # Resolves a filter value to something a human recognises, using the
  # collection the page declared. Falls back to the raw value.
  def filter_chip_value(filter, value)
    # A blank value only reaches here when it differs from the default, so it
    # is the include_blank choice ("All") rather than "nothing selected".
    return filter[:include_blank].to_s if value.blank? && filter[:include_blank].is_a?(String)

    collection = filter[:collection]
    return value.to_s if collection.blank?

    match = Array(collection).find do |option|
      filter_option_value(option).to_s == value.to_s
    end
    match ? filter_option_label(match) : value.to_s
  end

  # simple_form's `collection:` accepts [label, value] pairs, records, and bare
  # strings - a plain string is its own value.
  def filter_option_value(option)
    return option.last if option.is_a?(Array)

    option.respond_to?(:id) ? option.id : option
  end

  # Mirrors simple_form's default label_method lookup so a chip shows the same
  # text the select does, rather than the object's inspect output.
  def filter_option_label(option)
    return option.first.to_s if option.is_a?(Array)

    [ :to_label, :name, :title ].each do |method|
      return option.public_send(method).to_s if option.respond_to?(method)
    end
    option.to_s
  end
end
