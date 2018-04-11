class Group < ApplicationRecord
  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships

  has_many :expenses, dependent: :destroy

  validates :name, presence: true, uniqueness: true

  # add a user to this group - update memberships
  def add_user(user)
    Membership.create(user: user, group: self)
  end

  # add an expense to this group - update payments
  def add_expense(expense)
    users.each do |user|
      if user == expense.user
        Payment.create(user: user, expense: expense, paid: true)
      else
        Payment.create(user: user, expense: expense, paid: false)
      end
    end
  end
end
