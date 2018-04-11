class Expense < ApplicationRecord
  belongs_to :user
  belongs_to :group

  has_many :payments, dependent: :destroy
  has_many :users, through: :payments

  validates :date, :user, :group, presence: true
  validates :description, presence: true, uniqueness: { scope: :group }
  validates :total, presence: true, numericality:
  {
    greater_than: 0,
    message: 'total must be greater than zero'
  }
  validates :category, presence: true, inclusion: { in:
    [
      'Food & Drink',
      'Home',
      'Transportation',
      'Utilities',
      'Entertainment',
      'Other'
    ] }
end
