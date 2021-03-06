require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:user1) { User.create(email: 'UserOne@gmail.com', password: '1234567', first_name: 'User', last_name: 'One') }
  let!(:user2) { User.create(email: 'UserTwo@gmail.com', password: '1234567', first_name: 'User', last_name: 'Two') }
  let!(:user3) { User.create(email: 'UserThree@gmail.com', password: '1234567', first_name: 'User', last_name: 'Three') }
  let!(:groupA) { Group.create(name: 'Roommates') }
  let!(:groupB) { Group.create(name: 'Trivia Team') }
  let!(:membership1) { Membership.create(user: user1, group: groupA) }
  let!(:membership2) { Membership.create(user: user1, group: groupB) }
  let!(:membership3) { Membership.create(user: user2, group: groupA) }
  let!(:membership4) { Membership.create(user: user3, group: groupB) }
  let!(:expense1) { Expense.create(user: user1, group: groupA, date: '05012018', total: 1500.00, description: 'May rent', category: 'Home') }

  describe 'validations' do
    it 'is not valid without a first name' do
      user = User.new
      user.valid?
      expect(user.errors.messages[:first_name]).to include("can't be blank")
    end

    it 'is not valid without a last name' do
      user = User.new
      user.valid?
      expect(user.errors.messages[:last_name]).to include("can't be blank")
    end

    it 'is not valid without a email' do
      user = User.new
      user.valid?
      expect(user.errors.messages[:email]).to include("can't be blank")
    end

    it 'is not valid without a password' do
      user = User.new
      user.valid?
      expect(user.errors.messages[:password]).to include("can't be blank")
    end

    it 'is not valid with a duplicate email' do
      user = User.new(email: 'UserOne@gmail.com')
      user.valid?
      expect(user.errors.messages[:email]).to include('has already been taken')
    end

    it 'is not valid with a password less than 6 characters' do
      user = User.new(password: 'hello')
      user.valid?
      expect(user.errors.messages[:password]).to include('is too short (minimum is 6 characters)')
    end

    it "is not valid if the email does not have an '@'" do
      user = User.new(email: '.')
      user.valid?
      expect(user.errors.messages[:email]).to include("must have an '@' and a '.'")
    end

    it "is not valid if the email does not have a '.'" do
      user = User.new(email: '@')
      user.valid?
      expect(user.errors.messages[:email]).to include("must have an '@' and a '.'")
    end

    it "is not valid if the email does not have an '@' and a '.'" do
      user = User.new(email: 'email')
      user.valid?
      expect(user.errors.messages[:email]).to include("must have an '@' and a '.'")
    end

    it 'is valid with correct data' do
      expect(User.new(first_name: 'User', last_name: 'Name', email: 'userName@gmail.com', password: 'longEnough').valid?).to be true
    end
  end

  describe '#full_name' do
    it 'returns the full name' do
      expect(user1.full_name).to eq('User One')
      expect(user2.full_name).to eq('User Two')
      expect(user3.full_name).to eq('User Three')
    end
  end

  describe '#memberships' do
    it 'has many memberships' do
      expect(user1.memberships.size).to eq(2)
      expect(user2.memberships.size).to eq(1)
      expect(user3.memberships.size).to eq(1)
    end

    it 'deletes membership when destroyed' do
      expect { user3.destroy }.to change(Membership, :count).by(-1)
      expect { user1.destroy }.to change(Membership, :count).by(-2)
    end
  end

  describe '#groups' do
    it 'has many groups through memberships' do
      expect(user1.groups.size).to eq(2)
      expect(user2.groups.size).to eq(1)
    end
  end

  describe '#join_group' do
    it 'creates a new membership record with correct data' do
      group_c = Group.create(name: 'Bowling Team')
      new_membership = user1.join_group(group_c)
      expect(new_membership).not_to be_nil
      expect(Membership.count).to eq(5)
      expect(user1.groups).to include(group_c)
      expect(group_c.users).to include(user1)
    end

    it 'returns nil and make no modifications if membership already exists' do
      dup_membership = user1.join_group(groupA)
      expect(dup_membership).to be_nil
      expect(Membership.count).to eq(4)
      expect(user1.groups).to include(groupA)
      expect(groupA.users).to include(user1)
    end
  end
end
