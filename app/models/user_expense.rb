# User to Expenses table
class UserExpense < ApplicationRecord
  belongs_to :user
  belongs_to :expense

  validates :expense, uniqueness: { scope: :user }
  validates :user, uniqueness: { scope: :expense }
end
