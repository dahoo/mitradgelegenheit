require 'rails_helper'

RSpec.describe TracksController, type: :controller do
  let(:admin) { FactoryGirl.create :admin }

  let(:track) { FactoryGirl.create :track_attributes }

  let(:track_attributes) do
    attrs = FactoryGirl.attributes_for :track_attributes
    {track_track: attrs[:track_points],
     track_starts: attrs[:starts],
     track_ends: attrs[:ends]}
  end

  let(:valid_attributes) do
    {
      track: {
        name: 'Potsdam',
        link: '',
        start_times_attributes: {
          '1425126589432' => {
            day_of_week: '4',
            'time(1i)' => '2015',
            'time(2i)' => '2',
            'time(3i)' => '28',
            'time(4i)' => '09',
            'time(5i)' => '00',
            '_destroy' => 'false'
          }
        },
        starts_attributes: {
          '1425126589422' => {
            description: 'Lietzensee',
            time: '0'
          }
        },
        ends_attributes: {
          '1425126589429' => {
            description: 'Hasso-Plattner-Institut',
            time: '60'
          }
        }
      }
    }.merge track_attributes
  end

  let(:valid_track) do
    FactoryGirl.create :track
  end

  let(:invalid_attributes) do
    {
      track: {
        name: '',
        link: '',
        start_times_attributes: {
          '1425126589432' => {
            day_of_week: '4',
            'time(1i)' => '2015',
            'time(2i)' => '2',
            'time(3i)' => '28',
            'time(4i)' => '09',
            'time(5i)' => '00',
            '_destroy' => 'false'
          }
        },
        starts_attributes: {
          '1425126589422' => {
            description: 'Lietzensee',
            time: '0'
          }
        },
        ends_attributes: {
          '1425126589429' => {
            description: 'Hasso-Plattner-Institut',
            time: '60'
          }
        }
      }
    }.merge track_attributes
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # TracksController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe 'GET show' do
    it 'assigns the requested track as @track' do
      get :show, {id: valid_track.to_param}, valid_session
      expect(assigns(:track)).to eq(valid_track)
    end
  end

  describe 'GET new' do
    it 'assigns a new track as @track' do
      get :new, {}, valid_session
      expect(assigns(:track)).to be_a_new(Track)
    end
  end

  describe 'GET edit' do
    before { sign_in admin }

    it 'assigns the requested track as @track' do
      get :edit, {id: valid_track.to_param}, valid_session
      expect(assigns(:track)).to eq(valid_track)
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new Track' do
        expect do
          post :create, valid_attributes, valid_session
        end.to change(Track, :count).by(1)
      end

      it 'assigns a newly created track as @track' do
        post :create, valid_attributes, valid_session
        expect(assigns(:track)).to be_a(Track)
        expect(assigns(:track)).to be_persisted
      end

      it 'redirects to the track map' do
        post :create, valid_attributes, valid_session
        expect(response).to redirect_to(root_path)
      end
    end

    describe 'with invalid params' do
      it 'assigns a newly created but unsaved track as @track' do
        post :create, {track: invalid_attributes}.merge(track_attributes), valid_session
        expect(assigns(:track)).to be_a_new(Track)
      end

      it "re-renders the 'new' template" do
        post :create, {track: invalid_attributes}.merge(track_attributes), valid_session
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT update' do
    before { sign_in admin }

    describe 'with valid params' do
      let(:new_attributes) do
        FactoryGirl.attributes_for :new_track_attributes
      end

      it 'updates the requested track' do
        put :update, {id: valid_track.to_param, track: new_attributes}.merge(track_attributes), valid_session
        valid_track.reload
        expect(assigns(:track).name).to eq(valid_track.name)
      end

      it 'assigns the requested track as @track' do
        put :update, {id: valid_track.to_param, track: valid_attributes}.merge(track_attributes), valid_session
        expect(assigns(:track)).to eq(valid_track)
      end

      it 'redirects to the track' do
        put :update, {id: valid_track.to_param, track: valid_attributes}.merge(track_attributes), valid_session
        expect(response).to redirect_to(valid_track)
      end
    end

    describe 'with invalid params' do
      it 'assigns the track as @track' do
        put :update, {id: valid_track.to_param}.merge(invalid_attributes), valid_session
        expect(assigns(:track)).to eq(valid_track)
      end

      it "re-renders the 'edit' template" do
        put :update, {id: valid_track.to_param}.merge(invalid_attributes), valid_session
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE destroy' do
    before { sign_in admin }

    it 'destroys the requested track' do
      valid_track
      expect do
        delete :destroy, {id: valid_track.to_param}, valid_session
      end.to change(Track, :count).by(-1)
    end

    it 'redirects to the tracks list' do
      delete :destroy, {id: valid_track.to_param}, valid_session
      expect(response).to redirect_to(root_url)
    end
  end
end
