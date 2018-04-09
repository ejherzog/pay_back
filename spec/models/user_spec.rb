require 'rails_helper'

RSpec.describe User, type: :model do
 let!(:user1) { User.create(email: 'UserOne@gmail.com', password: '123', first_name: 'User', last_name: 'One') }

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
      user = User.new(email: 'UserOne@gmail.com', password: 'validLength', first_name: 'Hello', last_name: 'World')
      user.valid?
      print user.errors.messages
      expect(user.errors.messages[:email]).to include('has already been taken')
    end

    it 'is not valid with a password less than 6 characters' do
      user = User.new(password: 'hello')
      user.valid?
      expect(user.errors.messages[:password]).to include('is too short (minimum is 6 characters)')
    end
  end
end
