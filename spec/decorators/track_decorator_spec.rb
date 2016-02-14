require 'rails_helper'

describe TrackDecorator, type: :decorator do
  let(:track) { FactoryGirl.create(:track).decorate }

  describe 'to_geo_json' do
    subject { track.to_geo_json }

    it 'is expected to be of type FeatureCollection' do
      expect(subject[:type]).to eq 'FeatureCollection'
    end

    it 'is expected to have the correct number of features' do
      expect(subject[:features].size).to eq 3
    end

    it 'is have an URL' do
      expect(subject[:features].first[:properties][:url]).to eq 'http://test.tld/tracks/1'
    end
  end
end
