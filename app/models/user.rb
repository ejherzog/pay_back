# User table
class User < ApplicationRecord
  has_many :groups, through: :memberships
  has_many :expenses, through: :user_expenses

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }
  validates :first_name, :last_name, presence: true
end
