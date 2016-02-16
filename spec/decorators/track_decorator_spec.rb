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

    it 'is expected to have an URL' do
      expect(subject[:features].first[:properties][:url]).to eq(
        'http://test.tld/tracks/1'
      )
    end

    it 'is expected to have a category' do
      expect(subject[:features].first[:properties][:category]).to eq 'other'
    end

    it 'is expected to have next occurences' do
      expect(subject[:features].first[:properties][:occurences_7_days]).to eq [
        '2016-02-16T00:44:29Z', '2016-02-23T00:44:29Z', '2016-02-16T00:44:29Z',
        '2016-02-23T00:44:29Z', '2016-02-16T00:44:29Z', '2016-02-23T00:44:29Z']
    end
  end
end
