require 'rails_helper'

RSpec.describe User, type: :model do

  it 'has a valid factory' do
    expect( FactoryGirl.create(:user)).to be_valid
  end

  context 'email field' do
    it 'must be present' do
      expect( FactoryGirl.build(:user, email: nil)).not_to be_valid
    end

    it 'must contain between 10 and 200 characters' do
      expect( FactoryGirl.build(:user).email.length).to be_between(10,200).inclusive
    end

    it 'must be unique' do
      FactoryGirl.create(:user, email: 'email@gmail.com')
      expect( FactoryGirl.build(:user, name: 'Jony', email: 'email@gmail.com')).not_to be_valid
    end
  end

  context 'name field' do
    it 'must be present' do
      expect( FactoryGirl.build(:user, name: nil)).not_to be_valid
    end

    it 'must contain between 1 and 200 characters' do
      expect( FactoryGirl.build(:user).name.length ).to be_between(1,200).inclusive
    end
  end

  context 'password field' do

    it 'must be present' do
      expect( FactoryGirl.build(:user, password: nil)).not_to be_valid
    end

    it 'between 8 and 30 characters' do
      expect( FactoryGirl.build(:user).password.length).to be_between(8,30).inclusive
    end

  end

end
