class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :group

  validates :user, uniqueness: { scope: :group }
  validates :group, uniqueness: { scope: :user }
end
