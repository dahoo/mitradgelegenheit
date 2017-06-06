# == Schema Information
#
# Table name: tracks
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  distance    :float
#  time        :string(255)
#  link        :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  color_index :integer
#  user_id     :integer
#  category    :string(255)
#  description :text             default("")
#
# Indexes
#
#  index_tracks_on_user_id  (user_id)
#

require 'rails_helper'

RSpec.describe Track, type: :model do
  let(:user) { FactoryGirl.create :user }
  let(:track) { FactoryGirl.create :track, user: user }

  it 'validates the category' do
    expect(track.update category: 'inexistent_category').to eq false
  end

  it 'assigns a color index after creation' do
    expect(track.color_index).to be_kind_of Integer
  end

  it 'returns a color' do
    expect(track.color).to be_kind_of String
  end

  describe 'scope active' do
    let!(:track_with_date) { FactoryGirl.create :track_with_date, user: user }
    let!(:track_with_passed_date) { FactoryGirl.create :track_with_passed_date, user: user }

    before { track }

    subject { described_class.active.pluck(:id) }

    it { is_expected.to match_array [track, track_with_date].map(&:id) }
  end

  describe '#point_list' do
    it 'returns an array of track point coordinates' do
      expect(track.points_list).to eq [[52.13, 13.14],
                                       [52.15, 13.14],
                                       [52.16, 13.16]]
    end
  end

  describe '#compute_length' do
    it 'returns an array of track point coordinates' do
      track.compute_length
      expect(track.distance).to be_within(0.1).of(3.98)
    end

    context 'after update' do
      it 'returns an array of track point coordinates' do
        track.track_points << FactoryGirl.create(:track_point)
        track.save
        track.compute_length
        expect(track.distance).to be_within(0.1).of(7.58)
      end
    end
  end

  describe '#next_occurence' do
    it "returns the track's next occurence" do
      date  = Date.parse("Tuesday")
      delta = date > Date.today ? 0 : 7
      date += delta
      expect(track.next_occurence).to eq(track.start_times.first.time.on(date))
    end
  end
end
