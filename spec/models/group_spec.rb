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

  describe '#add_user' do
    it 'creates a new membership record with correct data' do
      group_c = Group.create(name: 'Bowling Team')
      new_membership = group_c.add_user(user1)
      expect(new_membership).not_to be_nil
      expect(Membership.count).to eq(5)
      expect(user1.groups).to include(group_c)
      expect(group_c.users).to include(user1)
    end

    it 'returns nil and make no modifications if membership already exists' do
      dup_membership = groupA.add_user(user1)
      expect(dup_membership).to be_nil
      expect(Membership.count).to eq(4)
      expect(user1.groups).to include(groupA)
      expect(groupA.users).to include(user1)
    end
  end

  describe '#add_expense' do
    it 'adds a new payment record for each user in group' do
      group_d = Group.create(name: 'Test Group')
      Membership.create(user: user1, group: group_d)
      Membership.create(user: user2, group: group_d)
      Membership.create(user: user3, group: group_d)
      expense = Expense.create(user: user2, group: group_d, date: '05/06/2018', total: 30.00, description: 'something', category: 'Food & Drink')
      response = group_d.add_expense(expense)
      expect(response).not_to be_nil
      expect(Payment.count).to eq(3)
      expect(user1.expenses).to include(expense)
      expect(user2.expenses).to include(expense)
      expect(user3.expenses).to include(expense)
      expect(user1.payments.size).to eq(1)
      expect(user2.payments.size).to eq(1)
      expect(user3.payments.size).to eq(1)
    end

    it 'returns nil and makes no modifications if groups do not match' do
      expense = Expense.create(user: user2, group: groupA, date: '05/06/2018', total: 30.00, description: 'something', category: 'Food & Drink')
      response = groupB.add_expense(expense)
      expect(response).to be_nil
      expect(Payment.count).to eq(0)
      expect(user1.payments.size).to eq(0)
      expect(user2.payments.size).to eq(0)
      expect(user3.payments.size).to eq(0)
    end
  end
end
