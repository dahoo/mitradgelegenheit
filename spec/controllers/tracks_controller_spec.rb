require 'rails_helper'

RSpec.describe TracksController, :type => :controller do
  let(:admin) { FactoryGirl.create :admin }

  let(:valid_attributes) {
    FactoryGirl.attributes_for(:track_attributes)
  }

  let(:track_attributes) {
    {track_track: valid_attributes[:track_points],
     track_starts: valid_attributes[:starts],
     track_ends: valid_attributes[:ends]}
  }

  let(:valid_track) {
    FactoryGirl.create :track
  }

  let(:invalid_attributes) {
    FactoryGirl.attributes_for :track_attributes, name: ''
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # TracksController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all tracks as @tracks" do
      valid_track
      get :index, {}, valid_session
      expect(assigns(:tracks)).to eq([valid_track])
    end
  end

  describe "GET show" do
    it "assigns the requested track as @track" do
      get :show, {:id => valid_track.to_param}, valid_session
      expect(assigns(:track)).to eq(valid_track)
    end
  end

  describe "GET new" do
    it "assigns a new track as @track" do
      get :new, {}, valid_session
      expect(assigns(:track)).to be_a_new(Track)
    end
  end

  describe "GET edit" do
    before {sign_in admin}

    it "assigns the requested track as @track" do
      get :edit, {:id => valid_track.to_param}, valid_session
      expect(assigns(:track)).to eq(valid_track)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Track" do
        expect {
          post :create, {:track => valid_attributes}.merge(track_attributes), valid_session
        }.to change(Track, :count).by(1)
      end

      it "assigns a newly created track as @track" do
        post :create, {:track => valid_attributes}.merge(track_attributes), valid_session
        expect(assigns(:track)).to be_a(Track)
        expect(assigns(:track)).to be_persisted
      end

      it "redirects to the track map" do
        post :create, {:track => valid_attributes}.merge(track_attributes), valid_session
        expect(response).to redirect_to(root_path)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved track as @track" do
        post :create, {:track => invalid_attributes}.merge(track_attributes), valid_session
        expect(assigns(:track)).to be_a_new(Track)
      end

      it "re-renders the 'new' template" do
        post :create, {:track => invalid_attributes}.merge(track_attributes), valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update" do
    before {sign_in admin}

    describe "with valid params" do
      let(:new_attributes) {
        FactoryGirl.attributes_for :new_track_attributes
      }

      it "updates the requested track" do
        put :update, {:id => valid_track.to_param, :track => new_attributes}.merge(track_attributes), valid_session
        valid_track.reload
        expect(assigns(:track).name).to eq(valid_track.name)
      end

      it "assigns the requested track as @track" do
        put :update, {:id => valid_track.to_param, :track => valid_attributes}.merge(track_attributes), valid_session
        expect(assigns(:track)).to eq(valid_track)
      end

      it "redirects to the track" do
        put :update, {:id => valid_track.to_param, :track => valid_attributes}.merge(track_attributes), valid_session
        expect(response).to redirect_to(valid_track)
      end
    end

    describe "with invalid params" do
      it "assigns the track as @track" do
        put :update, {:id => valid_track.to_param, :track => invalid_attributes}.merge(track_attributes), valid_session
        expect(assigns(:track)).to eq(valid_track)
      end

      it "re-renders the 'edit' template" do
        put :update, {:id => valid_track.to_param, :track => invalid_attributes}.merge(track_attributes), valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    before {sign_in admin}

    it "destroys the requested track" do
      valid_track
      expect {
        delete :destroy, {:id => valid_track.to_param}, valid_session
      }.to change(Track, :count).by(-1)
    end

    it "redirects to the tracks list" do
      delete :destroy, {:id => valid_track.to_param}, valid_session
      expect(response).to redirect_to(root_url)
    end
  end
end
