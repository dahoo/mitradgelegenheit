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

FactoryGirl.define do
  factory :start_time do
    day_of_week 1
    time '2014-12-14 00:44:29'
    track nil
    is_repeated true

    factory :start_time_with_date do
      day_of_week nil
      date 2.days.from_now
      is_repeated false
    end

    factory :start_time_with_passed_date do
      day_of_week nil
      date 2.days.ago
      is_repeated false
    end
  end
end
