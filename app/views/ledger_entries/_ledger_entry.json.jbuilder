json.extract! ledger_entry, :id, :ledger_id, :comment, :amount_cents, :created_by_id, :created_by_type, :approved, :created_at, :updated_at
json.url ledger_entry_url(ledger_entry, format: :json)
