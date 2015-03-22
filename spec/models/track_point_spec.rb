require 'rails_helper'

RSpec.describe TrackPoint, type: :model do
  let(:track_point) { FactoryGirl.create :track_point }

  describe '#to_coordinates'
  it 'returns an array of coordinates' do
    expect(track_point.to_coordinates).to eq [52.13, 13.14]
  end
end
