require 'rails_helper'

RSpec.describe StartTime, type: :model do
  describe 'scope active' do
    let!(:start_time) { FactoryGirl.create :start_time }
    let!(:start_time_with_date) { FactoryGirl.create :start_time_with_date }
    let!(:start_time_with_passed_date) { FactoryGirl.create :start_time_with_passed_date }

    subject { described_class.active }

    it { is_expected.to match_array([start_time, start_time_with_date]) }
  end
end
