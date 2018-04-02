# Expense table
class Expense < ApplicationRecord
  belongs_to :group

  validates :date, :who_paid, presence: true
  validates :description, presence: true, uniqueness: { scope: :group }
  validates :total, presence: true, numericality:
    {
      greater_than: 0,
      message: '%<value> must be greater than zero'
    }
  validates :category, inclusion: { in:
    [
      'Food & Drink',
      'Home',
      'Transportation',
      'Utilities',
      'Entertainment',
      'Other'
    ] }
end
