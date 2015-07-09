require 'rails_helper'

RSpec.describe TracksController, type: :controller do
  let(:user) { FactoryGirl.create :user }
  let(:user_2) { FactoryGirl.create :user_2 }
  let(:admin) { FactoryGirl.create :admin }

  let(:track) { FactoryGirl.create :track_attributes }

  let(:track_attributes) do
    attrs = FactoryGirl.attributes_for :track_attributes
    {points: attrs[:track_points]}
  end

  let(:is_repeated) { 'on' }

  let(:valid_attributes) do
    {
      track: {
        name: 'Name',
        link: '',
        start_times_attributes: {
          '1425126589432' => {
            is_repeated: is_repeated,
            day_of_week: '4',
            'date(1i)' => '2015',
            'date(2i)' => '2',
            'date(3i)' => '3',
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
            description: 'Start',
            time: '0',
            latitude: '52.2',
            longitude: '13.4'
          }
        },
        ends_attributes: {
          '1425126589429' => {
            description: 'End',
            time: '60',
            latitude: '52.4',
            longitude: '13.6'
          }
        }
      }.merge(track_attributes)
    }
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
            description: 'Start',
            time: '0'
          }
        },
        ends_attributes: {
          '1425126589429' => {
            description: 'End',
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
      get :show, {id: valid_track.to_param}
      expect(assigns(:track)).to eq(valid_track)
    end
  end

  describe 'GET new' do
    before { sign_in user }

    it 'assigns a new track as @track' do
      get :new, {}
      expect(assigns(:track)).to be_a_new(Track)
    end
  end

  describe 'GET edit' do
    let(:valid_track) { FactoryGirl.create :track, user: user }
    before { sign_in user }

    it 'assigns the requested track as @track' do
      get :edit, {id: valid_track.to_param}
      expect(assigns(:track)).to eq(valid_track)
    end
  end

  describe 'POST create' do
    before { sign_in user }

    describe 'with valid params' do
      it 'creates a new Track' do
        expect do
          post :create, valid_attributes
        end.to change(Track, :count).by(1)
      end

      it 'creates a track with a weekday' do
        post :create, valid_attributes
        expect(Track.first.start_times.first.day_of_week).to eq 4
        expect(Track.first.start_times.first.date).to eq nil
      end

      it 'creates a track with track points' do
        post :create, valid_attributes
        expect(Track.first.track_points.size).to eq 3
      end

      it "sets the track's length" do
        post :create, valid_attributes
        expect(Track.first.distance).to be_within(0.1).of(4)
      end

      it "sets the user" do
        post :create, valid_attributes
        expect(Track.first.user_id).to eq user.id
      end

      context 'with date' do
        let(:is_repeated) { 'off' }

        it 'creates a track with a date' do
          post :create, valid_attributes
          expect(Track.first.start_times.first.day_of_week).to eq nil
          expect(Track.first.start_times.first.date).to eq Date.new(2015, 2, 3)
        end
      end

      it 'assigns a newly created track as @track' do
        post :create, valid_attributes
        expect(assigns(:track)).to be_a(Track)
        expect(assigns(:track)).to be_persisted
      end

      it 'redirects to the track' do
        post :create, valid_attributes
        expect(response).to redirect_to(Track.first)
      end
    end

    describe 'with invalid params' do
      it 'assigns a newly created but unsaved track as @track' do
        post :create, {track: invalid_attributes}.merge(track_attributes)
        expect(assigns(:track)).to be_a_new(Track)
      end

      it "re-renders the 'new' template" do
        post :create, {track: invalid_attributes}.merge(track_attributes)
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT update' do
    context 'as user' do
      before { sign_in user }

      context 'for own track' do
        let(:valid_track) { FactoryGirl.create :track, user: user }

        describe 'with valid params' do
          let(:new_attributes) do
            FactoryGirl.attributes_for(:new_track_attributes).merge(track_attributes)
          end

          it 'updates the requested track' do
            put :update, {id: valid_track.to_param, track: new_attributes}
            valid_track.reload
            expect(assigns(:track).name).to eq(valid_track.name)
          end

          it "updates the requested track's distance" do
            put :update, {id: valid_track.to_param, track: new_attributes}
            valid_track.reload
            expect(assigns(:track).distance).to be_within(0.1).of(4)
          end

          it 'assigns the requested track as @track' do
            put :update, {id: valid_track.to_param, track: new_attributes}
            expect(assigns(:track)).to eq(valid_track)
          end

          it 'redirects to the track' do
            put :update, {id: valid_track.to_param, track: new_attributes}
            expect(response).to redirect_to(valid_track)
          end
        end

        describe 'with invalid params' do
          it 'assigns the track as @track' do
            put :update, {id: valid_track.to_param}.merge(invalid_attributes)
            expect(assigns(:track)).to eq(valid_track)
          end

          it "re-renders the 'edit' template" do
            put :update, {id: valid_track.to_param}.merge(invalid_attributes)
            expect(response).to render_template('edit')
          end
        end
      end

      context 'for other track' do
        let(:valid_track) { FactoryGirl.create :track, user: user_2 }

        describe 'with valid params' do
          let(:new_attributes) do
            FactoryGirl.attributes_for(:new_track_attributes).merge(track_attributes)
          end

          it 'updates the requested track' do
            put :update, {id: valid_track.to_param, track: new_attributes}
            valid_track.reload
            expect(assigns(:track).name).to redirect_to root_path
          end
        end
      end
    end

    context 'as admin' do
      let(:valid_track) { FactoryGirl.create :track, user: user_2 }
      before { sign_in admin }

      describe 'with valid params' do
        let(:new_attributes) do
          FactoryGirl.attributes_for(:new_track_attributes).merge(track_attributes)
        end

        it 'updates the requested track' do
          put :update, {id: valid_track.to_param, track: new_attributes}
          valid_track.reload
          expect(assigns(:track).name).to eq(valid_track.name)
        end

        it 'redirects to the track' do
          put :update, {id: valid_track.to_param, track: new_attributes}
          expect(response).to redirect_to(valid_track)
        end
      end
    end
  end

  describe 'DELETE destroy' do
    context 'as user' do
      before { sign_in user }
      context 'for own track' do
        let(:valid_track) { FactoryGirl.create :track, user: user }

        it 'destroys the requested track' do
          valid_track
          expect do
            delete :destroy, {id: valid_track.to_param}
          end.to change(Track, :count).by(-1)
        end

        it 'redirects to the tracks list' do
          delete :destroy, {id: valid_track.to_param}
          expect(response).to redirect_to(root_url)
        end
      end

      context 'for other track' do
        let(:valid_track) { FactoryGirl.create :track, user: user_2 }

        it 'does not destroy the requested track' do
          valid_track
          expect do
            delete :destroy, {id: valid_track.to_param}
          end.not_to change(Track, :count)
        end

        it 'redirects to root' do
          delete :destroy, {id: valid_track.to_param}
          expect(response).to redirect_to(root_url)
        end
      end
    end

    context 'as admin' do
      let(:valid_track) { FactoryGirl.create :track, user: user_2 }
      before { sign_in admin }

      it 'destroys the requested track' do
        valid_track
        expect do
          delete :destroy, {id: valid_track.to_param}
        end.to change(Track, :count).by(-1)
      end

      it 'redirects to the tracks list' do
        delete :destroy, {id: valid_track.to_param}
        expect(response).to redirect_to(root_url)
      end
    end
  end
end
