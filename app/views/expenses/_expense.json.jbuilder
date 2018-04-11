json.extract! expense, :id, :date, :total, :description, :user_id, :group_id, :category, :created_at, :updated_at
json.url expense_url(expense, format: :json)
