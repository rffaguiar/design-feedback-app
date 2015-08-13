require 'rails_helper'

RSpec.describe Design, type: :model do

  it { should belong_to (:user) }

  it 'has a valid factory' do
    expect(FactoryGirl.create(:design)).to be_valid
  end

  context 'link field' do
    it 'is invalid without a link' do
      expect(FactoryGirl.build(:design, link: nil)).not_to be_valid
    end

    it 'must be unique' do
      d1 = FactoryGirl.create(:design, link: 'abcdefgh')
      d2 = FactoryGirl.build(:design, link: 'abcdefgh')
      expect(d2).not_to be_valid
    end
  end

  context 'title field' do
    it 'is valid if it\'s empty' do
      expect(FactoryGirl.build(:design, title: '')).to be_valid
    end

    it 'is invalid if it has more than 250 characters' do
      expect(FactoryGirl.build(:design, title: Faker::Lorem.characters(251))).not_to be_valid
    end
  end

  context 'subtitle field' do
    it 'is valid if it\'s empty' do
      expect(FactoryGirl.build(:design, subtitle: '')).to be_valid
    end

    it 'is invalid if it has more than 250 characters' do
      expect(FactoryGirl.build(:design, subtitle: Faker::Lorem.characters(251))).not_to be_valid
    end
  end

  it 'is invalid without a image_path' do
    expect(FactoryGirl.build(:design, image_path: nil)).not_to be_valid
  end

  it 'is invalid without a image_thumb_path' do
    expect(FactoryGirl.build(:design, image_thumb_path: nil)).not_to be_valid
  end

end
