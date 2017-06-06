# == Schema Information
#
# Table name: track_points
#
#  id         :integer          not null, primary key
#  track_id   :integer
#  latitude   :float
#  longitude  :float
#  index      :integer
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_track_points_on_track_id  (track_id)
#

require 'rails_helper'

RSpec.describe TrackPoint, type: :model do
  let(:track_point) { FactoryGirl.create :track_point }

  describe '#to_coordinates'
  it 'returns an array of coordinates' do
    expect(track_point.to_coordinates).to eq [52.13, 13.14]
  end
end
