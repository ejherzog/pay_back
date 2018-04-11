# Group table
class Group < ApplicationRecord
  has_many :memberships, dependent: :destroy
  has_many :expenses, dependent: :destroy
  has_many :users, through: :memberships

  validates :name, presence: true, uniqueness: true
end
