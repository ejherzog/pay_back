class User < ApplicationRecord
  has_many :memberships, dependent: :destroy
  has_many :groups, through: :memberships

  has_many :payments, dependent: :destroy
  has_many :expenses, through: :payments

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }
  validates :first_name, :last_name, presence: true

  validate :valid_email

  # add this user to an existing group - update memberships
  def join_group(group)
    membership = Membership.create(user: self, group: group)
    membership.valid? ? membership : nil
  end

  private

  def valid_email
    return if email.nil?
    errors.add(:email, "must have an '@' and a '.'") if (!email.include? '.') || (!email.include? '@')
  end
end
