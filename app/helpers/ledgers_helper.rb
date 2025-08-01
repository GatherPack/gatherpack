module LedgersHelper
  def as_currency(amount, opts = {})
    return "-" unless amount.present?
    classes = [ "money", "money-#{money_amount_class(amount)}" ]
    classes << "money-failed" if opts[:failed]
    classes << "money-pending" if opts[:finalized] == false
    content_tag :span, class: classes do
      amount.format(opts.merge(
        html_wrap: true,
        sign_positive: true
      )).html_safe
    end
  end

  def money_amount_class(amount)
    return unless amount.present?
    if amount.positive?
      "positive"
    else
      if amount.negative?
        "negative"
      else
        "zero"
      end
    end
  end

  def ledger_as_badge(ledger)
    content = ledger.balance.format(sign_positive: true) + " " + i("receipt") + " " + ledger.identifier_name
    tag.span content.html_safe, class: [ "badge", "money-bg-#{money_amount_class(ledger.balance)}" ]
  end

  def ledger_entry_as_badge(entry)
    content = i("coins") + " " + entry.amount.format(sign_positive: true)
    tag.span content.html_safe, class: [ "badge", "money-bg-#{entry.amount}" ]
  end

  def ledger_tag_as_badge(ltag)
    content = i("stamp") + " " + ltag.identifier_name
    tag.span content.html_safe, class: [ "badge" ], style: "background-color: #{ltag.color}; color: #{contrasting_color(ltag.color)}"
  end
end
