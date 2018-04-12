require 'rails_helper'

RSpec.describe Expense, type: :model do
  let!(:user1) { User.create(email: 'UserOne@gmail.com', password: '1234567', first_name: 'User', last_name: 'One') }
  let!(:user2) { User.create(email: 'UserTwo@gmail.com', password: '1234567', first_name: 'User', last_name: 'Two') }
  let!(:user3) { User.create(email: 'UserThree@gmail.com', password: '1234567', first_name: 'User', last_name: 'Three') }
  let!(:groupA) { Group.create(name: 'Roommates') }
  let!(:groupB) { Group.create(name: 'Trivia Team') }
  let!(:membership1) { Membership.create(user: user1, group: groupA) }
  let!(:membership2) { Membership.create(user: user1, group: groupB) }
  let!(:membership3) { Membership.create(user: user2, group: groupA) }
  let!(:membership4) { Membership.create(user: user3, group: groupB) }
  let!(:expense1) { Expense.create(date: '05/01/2018', total: 100.00, user: user1, group: groupA, description: 'May groceries', category: 'Food & Drink') }
  let!(:expense2) { Expense.create(date: '05/01/2018', total: 1500.00, user: user2, group: groupB, description: 'May rent', category: 'Home') }
  let!(:paymentA) { Payment.create(user: user1, expense: expense1, paid: false) }
  let!(:paymentB) { Payment.create(user: user2, expense: expense1, paid: false) }
  let!(:paymentC) { Payment.create(user: user1, expense: expense2, paid: false) }
  let!(:paymentD) { Payment.create(user: user3, expense: expense2, paid: false) }

  describe 'validations' do
    it 'is not valid without a date' do
      expense = Expense.new
      expense.valid?
      expect(expense.errors.messages[:date]).to include("can't be blank")
    end

    it 'is not valid without a total' do
      expense = Expense.new
      expense.valid?
      expect(expense.errors.messages[:total]).to include("can't be blank")
    end

    it 'is not valid without a user' do
      expense = Expense.new
      expense.valid?
      expect(expense.errors.messages[:user]).to include("can't be blank")
    end

    it 'is not valid without a group' do
      expense = Expense.new
      expense.valid?
      expect(expense.errors.messages[:group]).to include("can't be blank")
    end

    it 'is not valid without a description' do
      expense = Expense.new
      expense.valid?
      expect(expense.errors.messages[:description]).to include("can't be blank")
    end

    it 'is not valid without a category' do
      expense = Expense.new
      expense.valid?
      expect(expense.errors.messages[:category]).to include("can't be blank")
    end

    it 'is not valid when description is duplicated' do
      expense = Expense.new(group: groupB, description: 'May rent')
      expense.valid?
      expect(expense.errors.messages[:description]).to include('has already been taken')
    end

    it 'is not valid when the total is zero' do
      expense = Expense.new(total: 0.0)
      expense.valid?
      expect(expense.errors.messages[:total]).to include('total must be greater than zero')
    end

    it 'is not valid when the total is negative' do
      expense = Expense.new(total: -2.00)
      expense.valid?
      expect(expense.errors.messages[:total]).to include('total must be greater than zero')
    end

    it "is not valid when the category is 'Random'" do
      expense = Expense.new(category: 'Random')
      expense.valid?
      expect(expense.errors.messages[:category]).to include('is not included in the list')
    end

    it 'is valid with correct data' do
      expense = Expense.create(date: '05/05/2018', total: 1000.00, user: user1, group: groupA, description: 'May something', category: 'Other')
      expect(expense.valid?).to be true
    end
  end

  describe '#payments' do
    it 'has many payments' do
      expect(expense1.payments.size).to eq(2)
      expect(expense2.payments.size).to eq(2)
    end

    it 'deletes payments when destroyed' do
      expect { expense1.destroy }.to change(Payment, :count).by(-2)
      expect { expense2.destroy }.to change(Payment, :count).by(-2)
    end
  end

  describe '#users' do
    it 'has many users through payments' do
      expect(expense1.users.size).to eq(2)
      expect(expense2.users.size).to eq(2)
    end
  end
end
