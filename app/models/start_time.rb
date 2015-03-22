class StartTime < ActiveRecord::Base
  belongs_to :track
  serialize :time, Tod::TimeOfDay

  before_save :check_is_repeated

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

  def day
    if date.blank?
      day_of_week_name
    else
      I18n.l date
    end
  end
end
