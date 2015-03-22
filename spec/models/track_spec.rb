require 'rails_helper'

RSpec.describe Track, type: :model do
  let(:track) { FactoryGirl.create :track }

  it 'assigns a color index after creation' do
    expect(track.color_index).to be_kind_of Integer
  end

  it 'returns a color' do
    expect(track.color).to be_kind_of String
  end

  describe 'scope active' do
    let!(:track_with_date) { FactoryGirl.create :track_with_date }
    let!(:track_with_passed_date) { FactoryGirl.create :track_with_passed_date }

    before do
      track
    end

    subject { described_class.active.pluck(:id) }

    it { is_expected.to match_array [track, track_with_date].map(&:id) }
  end
end
