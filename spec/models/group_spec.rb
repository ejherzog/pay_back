require 'rails_helper'

RSpec.describe Group, type: :model do
  let!(:user1) { User.create(email: 'UserOne@gmail.com', password: '1234567', first_name: 'User', last_name: 'One') }
  let!(:user2) { User.create(email: 'UserTwo@gmail.com', password: '1234567', first_name: 'User', last_name: 'Two') }
  let!(:user3) { User.create(email: 'UserThree@gmail.com', password: '1234567', first_name: 'User', last_name: 'Three') }
  let!(:groupA) { Group.create(name: 'Roommates') }
  let!(:groupB) { Group.create(name: 'Trivia Team') }
  let!(:membership1) { Membership.create(user: user1, group: groupA) }
  let!(:membership2) { Membership.create(user: user1, group: groupB) }
  let!(:membership3) { Membership.create(user: user2, group: groupA) }
  let!(:membership4) { Membership.create(user: user3, group: groupB) }
  let!(:expense1) { Expense.create(user: user1, group: groupA, date: '05/01/2018', total: 1500.00, description: 'May rent', category: 'Home') }
  let!(:expense2) { Expense.create(user: user1, group: groupB, date: '05/01/2018', total: 1600.00, description: 'May rent', category: 'Home') }
  let!(:expense3) { Expense.create(user: user2, group: groupA, date: '05/01/2018', total: 1700.00, description: 'May groceries', category: 'Food & Drink') }

  describe 'validations' do
    it 'is not valid without a name' do
      group = Group.new
      group.valid?
      expect(group.errors.messages[:name]).to include("can't be blank")
    end
  end

  describe '#expenses' do
    it 'has many expenses' do
      expect(groupA.expenses.size).to eq(2)
      expect(groupB.expenses.size).to eq(1)
    end

    it 'deletes expenses when destroyed' do
      expect { groupA.destroy }.to change(Expense, :count).by(-2)
      expect { groupB.destroy }.to change(Expense, :count).by(-1)
    end
  end

  describe '#memberships' do
    it 'has many memberships' do
      expect(groupA.memberships.size).to eq(2)
      expect(groupB.memberships.size).to eq(2)
    end

    it 'deletes membership when destroyed' do
      expect { groupA.destroy }.to change(Membership, :count).by(-2)
    end
  end

  describe '#users' do
    it 'has many users through memberships' do
      expect(groupA.users.size).to eq(2)
      user4 = User.create(email: 'UserFour@gmail.com', password: '1234567', first_name: 'User', last_name: 'Four')
      Membership.create(user: user4, group: groupB)
      expect(groupB.users.size).to eq(3)
    end
  end
end
