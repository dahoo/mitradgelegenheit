class StartTime < ActiveRecord::Base
  belongs_to :track
  serialize :time, Tod::TimeOfDay

  def day_of_week_name
    (I18n.t :'date.day_names')[(day_of_week + 1) % 7]
  end

  def time_h_m
    time.strftime('%H:%M')
  end
end
