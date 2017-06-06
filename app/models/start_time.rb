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

class StartTime < ActiveRecord::Base
  include TracksHelper

  belongs_to :track
  serialize :time, Tod::TimeOfDay

  scope :active, -> { where { (date.eq nil) | (date >= Time.zone.today) } }

  before_save :check_is_repeated

  validate :every, inclusion: {in: -1..4}

  def check_is_repeated
    if is_repeated
      self.date = nil
    else
      self.day_of_week = nil
    end
  end

  def day_of_week_name
    if day_of_week < 7
      (I18n.t :'date.day_names')[(day_of_week + 1) % 7]
    else
      special_days_of_week_names[day_of_week]
    end
  end

  def time_h_m
    time.strftime('%H:%M')
  end

  def to_s
    every_text = if is_repeated and day_of_week != 10
      every_names_inline(day).invert[every]
    else
      day
    end
    "#{every_text}, #{time_h_m}"
  end

  def day
    if date.blank?
      day_of_week_name
    else
      I18n.l date
    end
  end

  def next_occurence
    occurences = next_occurences(1)
    occurences.first if occurences
  end

  def compute_schedule
    schedule = IceCube::Schedule.new(time.on(track.created_at))
    rule = if day_of_week < 7
      if every >= 0 and every < 7
        IceCube::Rule.weekly(every).day((day_of_week + 1) % 7)
      elsif every < 0
        IceCube::Rule.monthly.day_of_week((day_of_week + 1) % 7 => [-1])
      elsif every > 10
        IceCube::Rule.monthly.day_of_week((day_of_week + 1) % 7 => [every - 10])
      end
    elsif day_of_week == 10
      IceCube::Rule.daily
    elsif day_of_week == 11
      IceCube::Rule.weekly.day(1, 2, 3, 4, 5)
    elsif day_of_week == 12
      IceCube::Rule.weekly.day(6, 0)
    end
    schedule.add_recurrence_rule(rule)
    schedule
  end

  def next_occurences(count)
    if is_repeated
      schedule = compute_schedule
      schedule.next_occurrences(count)
    else
      [date] if Time.zone.today <= date
    end
  end

  def next_occurences_in_days(days)
    if is_repeated
      schedule = compute_schedule
      schedule.occurrences_between(
        Time.zone.today.beginning_of_day,
        days.days.from_now.end_of_day)
    else
      [date] if Time.zone.today <= date && date <= days.days.from_now.to_date
    end
  end
end
