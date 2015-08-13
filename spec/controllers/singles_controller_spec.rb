require 'rails_helper'

RSpec.describe SinglesController, type: :controller do

  context "logged user" do
    describe "GET #show" do
      before(:each) do
        @user = FactoryGirl.create(:user)
        sign_in @user
        #a random design is being created: meaning that the user above is accessing someone's design
        @design = FactoryGirl.create(:design)
      end

      it 'should be successfull' do
        get :show, design_link: @design.link
        expect(response).to have_http_status(:ok)
      end

      it 'assigns @design' do
        get :show, design_link: @design.link
        expect(assigns(:design)).to be_kind_of(Design)
      end

      it 'assigns @spots with 0 or more' do
        get :show, design_link: @design.link
        expect(assigns(:spots).count).to be >= 0
      end

      it 'renders the show template' do
        get :show, design_link: @design.link
        expect(response).to render_template('show')
      end
    end

    describe "POST #create" do
      before(:each) do
        @user = FactoryGirl.create(:user)
        sign_in @user
      end

      # let(:image_upload) { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'file_tests', 'img', 'home-img.jpg'), 'image/jpg')}

      let(:png_upload) do
        my_png = File.new(Rails.root.join('spec', 'file_tests', 'img', 'darth_vader.png'))
        ActionDispatch::Http::UploadedFile.new(tempfile: my_png, filename: File.basename(my_png), type: 'image/png')
      end

      let(:jpeg_upload) do
        my_jpeg = File.new(Rails.root.join('spec', 'file_tests', 'img', 'pikachu.jpeg'))
        ActionDispatch::Http::UploadedFile.new(tempfile: my_jpeg, filename: File.basename(my_jpeg), type: 'image/jpeg')
      end

      let(:jpg_upload) do
        my_jpg = File.new(Rails.root.join('spec', 'file_tests', 'img', 'home-img.jpg'))
        ActionDispatch::Http::UploadedFile.new(tempfile: my_jpg, filename: File.basename(my_jpg), type: 'image/jpg')
      end

      let (:gif_upload) do
        my_gif = File.new(Rails.root.join('spec','file_tests', 'img', 'nyan_cat.gif'))
        ActionDispatch::Http::UploadedFile.new(tempfile: my_gif, filename: File.basename(my_gif), type: 'image/gif')
      end

      it 'should upload a file successfully' do
        expect {
          xhr :post, :create, format: :json, design_images: {0 => jpg_upload}
        }.to change(Design, :count).by(1)

        expect(response).to have_http_status(:ok)
      end

      it 'should upload 3 files successfully' do
        expect {
          xhr :post, :create, format: :json, design_images: {0 => jpg_upload, 1 => jpeg_upload, 2 => png_upload}
        }.to change(Design, :count).by(3)

        expect(response).to have_http_status(:ok)
      end

      it 'should not upload a file with different extensions than JPG, JPEG and PNG' do
        expect{
          xhr :post, :create, format: :json, design_images: {0 => gif_upload}
        }.to raise_exception('Not Permitted Filetype')
      end

      it 'TBD - should not upload a file bigger than 25MB'

      context 'in HTML response format' do
        it 'should redirect to :individuais_path' do
          post :create, design_images: {0 => jpg_upload}
          expect(response).to redirect_to(:individuais)
        end
      end

      context 'in JSON response format' do
        it 'should stay in the same page with :ok (200) status' do
          xhr :post, :create, format: :json, design_images: {0 => jpg_upload}
          expect(response).to have_http_status(:ok)
        end
      end
    end

    describe 'PATCH #update_title' do
      before(:each) do
        @user_with_singles = FactoryGirl.create(:user_with_singles)
        sign_in @user_with_singles
        @design_from_user = @user_with_singles.designs.first
      end

      it 'should be successfull' do
        xhr :patch, :update_title, design_id: @design_from_user.id
        expect(response).to have_http_status(:ok)
      end

      it 'should update the title' do
        xhr :patch, :update_title, design_id: @design_from_user.id, design_title: 'My new title'
        expect(response).to have_http_status(:ok)
      end
    end

    describe 'PATCH #update_subtitle' do
      before(:each) do
        @user_with_singles = FactoryGirl.create(:user_with_singles)
        sign_in @user_with_singles
        @design_from_user = @user_with_singles.designs.first
      end

      it 'should be successfull' do
        xhr :patch, :update_subtitle, design_id: @design_from_user.id
        expect(response).to have_http_status(:ok)
      end

      it 'should update the subtitle' do
        xhr :patch, :update_subtitle, design_id: @design_from_user.id, design_subtitle: 'My new subtitle'
        expect(response).to have_http_status(:ok)
      end
    end

  end

  context "guest user" do
    describe "GET #show" do

      context 'invalid link' do
        let (:invalid_link) { 'hu3hu3hu3' }

        it 'should have a flash[:notice]' do
          get :show, design_link: :invalid_link
          expect(flash[:notice]).not_to be_empty
        end

        it 'should redirect to home' do
          get :show, design_link: :invalid_link
          expect(response).to redirect_to(:root)
        end
      end

      context 'valid link' do
        before(:each) do
          @design = FactoryGirl.create(:design)
        end

        it "should not have access to image" do
          get :show, design_link: @design.link
          expect(response).to have_http_status(:found)
        end

        it "redirect to sign up page" do
          get :show, design_link: @design.link
          expect(response).to redirect_to(:new_user_registration)
        end
      end
    end
  end
end
