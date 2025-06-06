json.extract! ledger, :id, :name, :team_id, :balance_cents, :created_at, :updated_at
json.url ledger_url(ledger, format: :json)
