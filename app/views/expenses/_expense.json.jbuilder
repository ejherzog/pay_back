json.extract! expense, :id, :total, :description, :date, :who_paid_id, :category, :created_at, :updated_at
json.url expense_url(expense, format: :json)
