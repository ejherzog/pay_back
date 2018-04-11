class Payment < ApplicationRecord
  belongs_to :user
  belongs_to :expense

  validates :expense, uniqueness: { scope: :user }
  validates :user, uniqueness: { scope: :expense }
  validates_inclusion_of :paid, in: [true, false]
end
