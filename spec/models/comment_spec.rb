require 'rails_helper'

RSpec.describe Comment, type: :model do

  it { should belong_to(:user) }
  it { should belong_to(:design) }
  it { should belong_to(:spot) }

  it 'has a valid factory' do
    expect( FactoryGirl.create(:comment)).to be_valid
  end

  context 'comment field' do

    it 'must have value' do
      expect( FactoryGirl.build(:comment, comment: nil)).not_to be_valid
    end

    it 'must have between 1 and 250 (included) characters' do
      expect( FactoryGirl.build(:comment).comment.length).to be_between(1,250).inclusive
    end

  end

end
