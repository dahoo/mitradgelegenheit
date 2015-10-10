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
    (I18n.t :'date.day_names')[(day_of_week + 1) % 7]
  end

  def time_h_m
    time.strftime('%H:%M')
  end

  def to_s
    every_text = ''
    every_text = every_names.invert[every] + ' ' if is_repeated
    "#{every_text}#{day}, #{time_h_m}"
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
    if every >= 0
      rule = IceCube::Rule.weekly(every).day((day_of_week + 1) % 7)
    else
      rule = IceCube::Rule.monthly.day_of_week((day_of_week + 1) % 7 => [-1])
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
