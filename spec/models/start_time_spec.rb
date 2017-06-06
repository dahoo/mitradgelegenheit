# == Schema Information
#
# Table name: start_times
#
#  id          :integer          not null, primary key
#  day_of_week :integer
#  time        :time
#  track_id    :integer
#  created_at  :datetime
#  updated_at  :datetime
#  date        :date
#  is_repeated :boolean
#  every       :integer          default(1)
#
# Indexes
#
#  index_start_times_on_track_id  (track_id)
#

require 'rails_helper'

RSpec.describe StartTime, type: :model do
  describe 'scope active' do
    let!(:start_time) { FactoryGirl.create :start_time }
    let!(:start_time_with_date) { FactoryGirl.create :start_time_with_date }
    let!(:start_time_with_passed_date) { FactoryGirl.create :start_time_with_passed_date }

    subject { described_class.active }

    it { is_expected.to match_array([start_time, start_time_with_date]) }
  end

  describe 'to_s' do
    let(:day_of_week) { 0 }
    let(:every) { 1 }
    let(:time) { '2014-12-14 00:44:29' }
    let(:start_time) do
      FactoryGirl.create :start_time,
        day_of_week: day_of_week,
        time: time,
        every: every
    end

    subject { start_time.to_s }


    context 'for Monday' do
      let(:day_of_week) { 0 }

      it { is_expected.to eq 'jeden Montag, 00:44' }
    end

    context 'for Sunday' do
      let(:day_of_week) { 6 }

      it { is_expected.to eq 'jeden Sonntag, 00:44' }
    end

    context 'for daily' do
      let(:day_of_week) { 10 }

      it { is_expected.to eq 'täglich, 00:44' }
    end

    context 'for weekdays' do
      let(:day_of_week) { 11 }

      it { is_expected.to eq 'jeden Mo.-Fr., 00:44' }
    end

    context 'for weekends' do
      let(:day_of_week) { 12 }

      it { is_expected.to eq 'jeden Sa., So., 00:44' }
    end

    context 'every x in month' do
      let(:day_of_week) { 0 }

      context 'first' do
        let(:every) { 11 }

        it { is_expected.to eq 'jeden ersten Montag im Monat, 00:44' }
      end

      context 'second' do
        let(:every) { 12 }

        it { is_expected.to eq 'jeden zweiten Montag im Monat, 00:44' }
      end

      context 'third' do
        let(:every) { 13 }

        it { is_expected.to eq 'jeden dritten Montag im Monat, 00:44' }
      end

      context 'fourth' do
        let(:every) { 14 }

        it { is_expected.to eq 'jeden vierten Montag im Monat, 00:44' }
      end

      context 'last' do
        let(:every) { -1 }

        it { is_expected.to eq 'jeden letzten Montag im Monat, 00:44' }
      end
    end
  end

  describe 'compute_schedule' do
    let(:day_of_week) { 0 }
    let(:time) { '2014-12-14 00:44:29' }
    let(:every) { 1 }
    let(:start_time) do
      FactoryGirl.create :start_time,
        day_of_week: day_of_week,
        time: time,
        every: every,
        track: FactoryGirl.create(:track)
    end

    subject { start_time.compute_schedule.to_s }


    context 'for Monday' do
      let(:day_of_week) { 0 }

      it { is_expected.to eq 'Weekly on Mondays' }
    end

    context 'for Sunday' do
      let(:day_of_week) { 6 }

      it { is_expected.to eq 'Weekly on Sundays' }
    end

    context 'for daily' do
      let(:day_of_week) { 10 }

      it { is_expected.to eq 'Daily' }
    end

    context 'for weekdays' do
      let(:day_of_week) { 11 }

      it { is_expected.to eq 'Weekly on Weekdays' }
    end

    context 'for weekends' do
      let(:day_of_week) { 12 }

      it { is_expected.to eq 'Weekly on Weekends' }
    end

    context 'every x in month' do
      let(:day_of_week) { 0 }

      context 'first' do
        let(:every) { 11 }

        it { is_expected.to eq 'Monthly on the 1st Monday' }
      end

      context 'second' do
        let(:every) { 12 }

        it { is_expected.to eq 'Monthly on the 2nd Monday' }
      end

      context 'third' do
        let(:every) { 13 }

        it { is_expected.to eq 'Monthly on the 3rd Monday' }
      end

      context 'fourth' do
        let(:every) { 14 }

        it { is_expected.to eq 'Monthly on the 4th Monday' }
      end

      context 'last' do
        let(:every) { -1 }

        it { is_expected.to eq 'Monthly on the last Monday' }
      end
    end
  end
end
