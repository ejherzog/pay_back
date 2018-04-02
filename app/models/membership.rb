# Group to User membership table
class Membership < ApplicationRecord
  belongs_to :group
  belongs_to :user

  validates :user, uniqueness: { scope: :group }
end
