# User table
class User < ApplicationRecord
  has_many :groups, through: :memberships
  has_many :expenses, through: :user_expenses

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }
  validates :first_name, :last_name, presence: true
  validate :valid_email

  def valid_email
    return if email.nil?
    errors.add(:email, "must have an '@' and a '.'") if (!email.include? '.') || (!email.include? '@')
  end
end
