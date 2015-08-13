require 'rails_helper'

RSpec.describe Admin, type: :model do

  it 'must have a valid factory' do
    expect( FactoryGirl.create(:admin)).to be_valid
  end

  it 'must have an email' do
    expect( FactoryGirl.build(:admin, email: nil)).not_to be_valid
  end

  it 'must have a password' do
    expect( FactoryGirl.build(:admin, password: nil)).not_to be_valid
  end

end
