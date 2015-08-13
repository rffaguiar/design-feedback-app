require 'rails_helper'

RSpec.describe DynamicPagesController, type: :controller do

  context "logged user" do

    describe "GET #individuais" do
      context "User with singles" do
        before(:each) do
          @user_with_singles = FactoryGirl.create(:user_with_singles, designs_count: 5)
          sign_in @user_with_singles
        end

        it 'should be successfull' do
          get :individuais
          expect(response).to have_http_status(:ok)
        end

        it 'assigns @singles with designs' do
          get :individuais
          expect(assigns(:singles).count).to be > 0
          expect(assigns(:singles).first).to be_kind_of(Design)
        end

        it 'renders the individuais template' do
          get :individuais
          expect(response).to render_template("individuais")
        end

      end

      context "User without singles" do
        before(:each) do
          @user_without_singles = FactoryGirl.create(:user)
          sign_in @user_without_singles
        end

        it 'should be successfull' do
          get :individuais
          expect(response).to have_http_status(:ok)
        end

        it 'assigns @singles with designs, but its empty' do
          get :individuais
          expect(assigns(:singles).count).to eq(0)
        end

        it 'renders the individuais template' do
          get :individuais
          expect(response).to render_template("individuais")
        end
      end
    end

    describe "GET #my_comments" do

      context "User with comments" do
        before(:each) do
          @user_with_comments = FactoryGirl.create(:user_with_comments, comments_count: 7)
          sign_in @user_with_comments
        end

        it 'should be successfull' do
          get :my_comments
          expect(response).to have_http_status(:ok)
        end

        it 'should show designs where the user has comments' do
          get :my_comments
          expect(assigns(:singles).count).to be > 0
          expect(assigns(:singles).first).to be_kind_of(Design)
        end

        it 'renders the my_comments template' do
          get :my_comments
          expect(response).to render_template('my_comments')
        end
      end

      context "User without comments" do
        before(:each) do
          @user_without_comments = FactoryGirl.create(:user)
          sign_in @user_without_comments
        end

        it 'should be successfull' do
          get :my_comments
          expect(response).to have_http_status(:ok)
        end

        it 'should not show designs, because its empty' do
          get :my_comments
          expect(assigns(:singles).count).to eql(0)
        end

        it 'renders the my_comments template' do
          get :my_comments
          expect(response).to render_template('my_comments')
        end
      end
    end
  end

  context "guest user" do

    describe "GET #individuais" do
      it "redirect to login page" do
        get :individuais
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(:new_user_session)
      end
    end

    describe "GET #my_comments" do
      it 'redirect to login page' do
        get :my_comments
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(:new_user_session)
      end
    end

  end


end
