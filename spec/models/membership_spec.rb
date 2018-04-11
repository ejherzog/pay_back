require 'rails_helper'

RSpec.describe Membership, type: :model do
  describe 'validations' do
    it 'is not valid without a user' do
      membership = Membership.new
      membership.valid?
      expect(membership.errors.messages[:user]).to include('must exist')
    end

    it 'is not valid without a group' do
      membership = Membership.new
      membership.valid?
      expect(membership.errors.messages[:group]).to include('must exist')
    end

    it 'is not valid to add a user to a group twice' do
      user = User.create(email: 'UserOne@gmail.com', password: '1234567', first_name: 'User', last_name: 'One')
      group = Group.create(name: 'Roommates')
      Membership.create(user: user, group: group)
      membership = Membership.create(user: user, group: group)
      membership.valid?
      expect(membership.errors.messages[:group]).to include('has already been taken')
    end
  end
end
