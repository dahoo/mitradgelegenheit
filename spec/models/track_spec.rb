require 'rails_helper'

RSpec.describe Track, type: :model do
  let(:track) { FactoryGirl.create :track }

  it 'assigns a color index after creation' do
    expect(track.color_index).to be_kind_of Integer
  end

  it 'returns a color' do
    expect(track.color).to be_kind_of String
  end
end
