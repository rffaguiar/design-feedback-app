require 'rails_helper'

RSpec.describe CommentsController, type: :controller do

  context 'logged user' do

    describe 'POST #create' do

      before(:each) do
        @user_with_comments = FactoryGirl.create(:user_with_comments)
        sign_in @user_with_comments
        @design = FactoryGirl.create(:design)
        # @design_with_spots = FactoryGirl.create(:design_with_spots)
      end

      it 'should have a comment text' do
        expect{
          xhr :post, :create, format: :json, 'spot-id' => 1, 'design-id' => @design.id, 'design-comment-text' => '', 'design-y-pos' =>  '1', 'design-x-pos' =>  '2'
        }.not_to change(Comment, :count)
      end

      it 'should have a design_id' do
        expect{
          xhr :post, :create, format: :json, 'spot-id' => 1, 'design-id' => '', 'design-comment-text' => 'Hellow', 'design-y-pos' =>  '1', 'design-x-pos' =>  '2'
        }.not_to change(Comment, :count)
      end

      context 'when Spot does not exist' do

        # let(:creating_spot_comment) { xhr :post, :create, format: :js, 'spot-id' => '', 'design-id' => @design.id, 'design-comment-text' => 'Lorem', 'design-y-pos' => '12345', 'design-x-pos' =>  '4563' }

        it 'should have a design Y position' do
          spots_before = Spot.count
          comments_before = Comment.count

          xhr :post, :create, format: :js, 'spot-id' => '', 'design-id' => @design.id, 'design-comment-text' => 'Lorem', 'design-y-pos' =>  '', 'design-x-pos' =>  '2'

          expect(Spot.count).to eq(spots_before)
          expect(Comment.count).to eq(comments_before)
        end

        it 'should have a design X position' do
          spots_before = Spot.count
          comments_before = Comment.count

          xhr :post, :create, format: :js, 'spot-id' => '', 'design-id' => @design.id, 'design-comment-text' => 'Lorem', 'design-y-pos' =>  '2', 'design-x-pos' =>  ''

          expect(Spot.count).to eq(spots_before)
          expect(Comment.count).to eq(comments_before)
        end

        it 'should create a Spot and a Comment' do
          spots_before = Spot.count
          comments_before = Comment.count

          xhr :post, :create, format: :js, 'spot-id' => '', 'design-id' => @design.id, 'design-comment-text' => 'Lorem', 'design-y-pos' => '134123', 'design-x-pos' =>  '2345345'

          expect(Spot.count).to eq(spots_before + 1)
          expect(Comment.count).to eq(comments_before + 1)
        end
      end # when spot does not exist

      context 'when Spot exists' do

        before(:each) do
          @design_with_spots = FactoryGirl.create(:design_with_spots)
        end

        it 'should create just a Comment' do
          spots_before = Spot.count
          comments_before = Comment.count

          xhr :post, :create, format: :js, 'spot-id' => @design_with_spots.spots.first.id, 'design-id' => @design_with_spots.id, 'design-comment-text' => 'Hellow', 'design-x-pos' => 150, 'design-y-pos' => 150

          expect(Spot.count).to eq(spots_before)
          expect(Comment.count).to eq(comments_before + 1)
        end
      end #when spot exists
    end # POST create

    describe "DELETE #delete" do
      before(:each) do
        @user_with_comments = FactoryGirl.create(:user_with_comments)
        sign_in @user_with_comments
      end

      it 'should have the comment_id' do
        xhr :delete, :delete, format: :js, comment_id: ''
        expect(response).to have_http_status(:found)
      end

      context 'last comment in spot' do
        before(:each) do
          @user_with_spots_and_one_comment = FactoryGirl.create(:user_with_spots_and_one_comment)
          sign_in @user_with_spots_and_one_comment
        end

        it 'should delete the comment AND the spot' do
          comments_before = Comment.count
          spots_before = Spot.count

          xhr :delete, :delete, format: :js, comment_id: @user_with_spots_and_one_comment.comments.first.id

          expect(comments_before).to eq(Comment.count + 1)
          expect(spots_before).to eq(Spot.count + 1)
        end
      end # last comment in spot

      context 'not the last comment in spot' do
        before(:each) do
          @user_with_spots_and_many_comments = FactoryGirl.create(:user_with_spots_and_many_comments)
          sign_in @user_with_spots_and_many_comments
        end

        it 'should delete just the comment in the spot' do
          comments_before = Comment.count
          spots_before = Spot.count

          xhr :delete, :delete, format: :js, comment_id: @user_with_spots_and_many_comments.comments.first.id

          expect(comments_before).to eq(Comment.count + 1)
          expect(spots_before).to eq(Spot.count)
        end
      end

      context 'commenter trying to delete other commenter\'s comment' do
        before(:each) do
          @user_with_spots_and_many_comments = FactoryGirl.create(:user_with_spots_and_many_comments)
          @another_user_with_spots_and_many_comments = FactoryGirl.create(:user_with_spots_and_many_comments)
          sign_in @user_with_spots_and_many_comments
        end

        it 'should not be possible' do
          xhr :delete, :delete, format: :js, comment_id: @another_user_with_spots_and_many_comments.comments.first.id
          expect(response).to have_http_status(:found)
        end
      end

    end # delete #delete

  end # logged user

  context 'guest user' do

    describe "POST #create" do

      before(:each) do
        @design = FactoryGirl.create(:design)
      end

      it 'should be unauthorized' do
        xhr :post, :create, format: :json, 'spot-id' => 1, 'design-id' => @design.id, 'design-comment-text' => 'something in text'
        expect(response).to have_http_status(:unauthorized)
      end

    end # post #create

    describe "DELETE #destroy" do

      before(:each) do
        @spot_with_comments = FactoryGirl.create(:spot_with_comments)
      end

      it 'should be unauthorized' do
        xhr :delete, :delete, format: :js, comment_id: @spot_with_comments.comments.first.id
        expect(response).to have_http_status(:unauthorized)
      end

    end # delete #destroy
  end # guest user

end
