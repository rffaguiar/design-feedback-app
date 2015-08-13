require 'rails_helper'

RSpec.describe StaticPagesController, type: :controller do

  describe "GET #home" do

    it "should be successfull" do
      get :home
      expect(response).to have_http_status(:ok)
    end

    it 'renders the home template' do
      get :home
      expect(response).to render_template('home')
    end

  end

  describe "GET #contact" do

    it 'should be successfull' do
      get :contact
      expect(response).to have_http_status(:ok)
    end

    it 'renders the contact template' do
      get :contact
      expect(response).to render_template('contact')
    end

  end

end
