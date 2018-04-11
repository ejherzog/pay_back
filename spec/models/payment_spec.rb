require 'rails_helper'

RSpec.describe Payment, type: :model do
  let!(:user1) { User.create(email: 'UserOne@gmail.com', password: '1234567', first_name: 'User', last_name: 'One') }
  let!(:user2) { User.create(email: 'UserTwo@gmail.com', password: '1234567', first_name: 'User', last_name: 'Two') }
  let!(:groupA) { Group.create(name: 'Roommates') }
  let!(:membership1) { Membership.create(user: user1, group: groupA) }
  let!(:membership2) { Membership.create(user: user2, group: groupA) }
  let!(:expense1) { Expense.create(user: user1, group: groupA, date: '05/01/2018', total: 1500.00, description: 'May rent', category: 'Home') }
  let!(:expense2) { Expense.create(user: user1, group: groupA, date: '05/03/2018', total: 600.00, description: 'May food', category: 'Food & Drink') }

  describe 'validations' do
    it 'is not valid without a user' do
      payment = Payment.new
      payment.valid?
      expect(payment.errors.messages[:user]).to include('must exist')
    end

    it 'is not valid without an expense' do
      payment = Payment.new
      payment.valid?
      expect(payment.errors.messages[:expense]).to include('must exist')
    end

    it 'is not valid without boolean paid field' do
      payment = Payment.new
      payment.valid?
      expect(payment.errors.messages[:paid]).to include('is not included in the list')
    end

    it 'is valid with correct data' do
      payment = Payment.create(user: user1, expense: expense1, paid: true)
      expect(payment.valid?).to be true
    end

    it 'is not valid to add an expense to a user twice' do
      print(user1.valid?)
      print(expense2.valid?)
      payment1 = Payment.create(user: user1, expense: expense2, paid: false)
      print(payment1.valid?)
      payment2 = Payment.create(user: user1, expense: expense2, paid: true)
      expect(payment2.errors.messages[:user]).to include('has already been taken')
    end
  end
end
