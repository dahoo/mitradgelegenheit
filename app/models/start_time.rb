class StartTime < ActiveRecord::Base
  include TracksHelper

  belongs_to :track
  serialize :time, Tod::TimeOfDay

  scope :active, -> { where{(date.eq nil) | (date >= Date.today) } }

  before_save :check_is_repeated

  validate :every, inclusion: { in: -1..4 }

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
    every_text = ""
    every_text = every_names.invert[every] + " " if is_repeated
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
    if is_repeated
      schedule = IceCube::Schedule.new(now = time.on(track.created_at))
      if every >= 0
        rule = IceCube::Rule.weekly(every).day((day_of_week + 1) % 7)
      else
        rule = IceCube::Rule.monthly.day_of_week((day_of_week + 1) % 7 => [-1])
      end
      schedule.add_recurrence_rule(rule)
      schedule.next_occurrence
    else
      date if Date.today <= date
    end
  end
end
