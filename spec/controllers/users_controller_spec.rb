require 'rails_helper'

RSpec.describe UsersController, :type => :controller do
  let(:user) { FactoryGirl.create :user }
  let(:admin) { FactoryGirl.create :admin }

  describe "GET index" do
    context 'not logged in' do
      it "returns http success" do
        get :index
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'as user' do
      before { sign_in user }

      it "returns http success" do
        get :index
        expect(response).to redirect_to root_path
      end
    end

    context 'as admin' do
      before { sign_in admin }

      it "returns http success" do
        get :index
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "GET show" do
    before { user }

    it "returns http success" do
      get :show, id: user.id
      expect(response).to have_http_status(:success)
    end
  end

end
