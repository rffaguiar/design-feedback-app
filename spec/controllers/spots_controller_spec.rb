require 'rails_helper'

RSpec.describe SpotsController, type: :controller do

  context 'logged user without Spot ownership' do
    describe 'DELETE #delete' do

      before(:each) do
        @user = FactoryGirl.create(:user)
        @spot = FactoryGirl.create(:spot)
        sign_in @user
      end

      it 'should not delete spots without ownership' do
        expect {
          xhr :delete, :delete, format: :js, spot_id: @spot.id
        }.not_to change(Spot, :count)
        expect(response).to redirect_to(:root)
      end

    end
  end

  context 'logged user with Spot ownership' do
    describe 'DELETE #delete' do

      before(:each) do
        @user_with_spots = FactoryGirl.create(:user_with_spots)
        sign_in @user_with_spots
      end

      it 'should have a spot_id' do
        expect {
          xhr :delete, :delete, format: :js, spot_id: ''
        }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it 'should have a spot to delete' do
        expect {
          xhr :delete, :delete, format: :js, spot_id: 12345
        }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it 'should delete a spot' do
        expect {
          xhr :delete, :delete, format: :js, spot_id: @user_with_spots.spots.first.id
        }.to change(Spot, :count).by(-1)
      end
    end
  end

  context 'guest user' do
    before(:each) do
      @spot = FactoryGirl.create(:spot)
    end

    describe 'DELETE #delete' do
      it 'should be unauthorized' do
        xhr :delete, :delete, format: :js, spot_id: @spot.id
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

end
