require 'rails_helper'

RSpec.describe Spot, type: :model do

  it { should belong_to(:design) }
  it { should belong_to(:user) }

  it 'has a valid factory' do
    expect( FactoryGirl.create(:spot)).to be_valid
  end

  context 'x_pos field' do
    it 'must have value' do
      expect( FactoryGirl.build(:spot, x_pos: nil)).not_to be_valid
    end

    it 'is numerical' do
      expect( FactoryGirl.build(:spot, x_pos: 'abc')).not_to be_valid
    end

    it 'is integer' do
      expect( FactoryGirl.build(:spot, x_pos: '122.0')).not_to be_valid
    end

    it 'is greater than 0' do
      expect( FactoryGirl.build(:spot, x_pos: '-122')).not_to be_valid
    end

  end

  context 'y_pos field' do
    it 'must have value' do
      expect( FactoryGirl.build(:spot, y_pos: nil)).not_to be_valid
    end

    it 'is numerical' do
      expect( FactoryGirl.build(:spot, y_pos: 'abc')).not_to be_valid
    end

    it 'is integer' do
      expect( FactoryGirl.build(:spot, y_pos: '122.0')).not_to be_valid
    end

    it 'is greater than 0' do
      expect( FactoryGirl.build(:spot, y_pos: '-122')).not_to be_valid
    end
  end

  it 'max 1 spot to [x_pos, y_pos] for each design_id' do
    design = FactoryGirl.create(:design)
    FactoryGirl.create(:spot, x_pos: '100', y_pos: '100', design_id: design.id)
    expect(FactoryGirl.build(:spot, x_pos: '100', y_pos: '100', design_id: design.id)).not_to be_valid
  end

end
