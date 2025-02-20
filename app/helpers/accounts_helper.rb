module AccountsHelper
  def as_currency(amount, opts = {})
    content_tag :span, class: [ 'money', "money-#{money_amount_class(amount)}" ] do
      amount.format(opts.merge(
        html_wrap: true,
        sign_positive: true
      )).html_safe
    end
  end

  def money_amount_class(amount)
    if amount.positive?
      'positive'
    else
      if amount.negative?
        'negative'
      else
        'zero'
      end
    end
  end

  def account_as_badge(account)
    content = account.balance.format(sign_positive: true) + ' ' + i('receipt') + ' ' + account.identifier_name
    tag.span content.html_safe, class: [ 'badge', account.balance.negative? ? 'text-bg-danger' : 'text-bg-success' ]
  end

  def holder_collection(account)
    {
      Person: policy_scope(Person).order(last_name: :asc, first_name: :asc).map { |p| [ "Person - #{p.identifier_name}", p.to_global_id.to_s ] },
      Event: policy_scope(Event).order(name: :asc).map { |e| [ "Event - #{e.identifier_name}", e.to_global_id.to_s ] }
    }
  end
end
