class StartTime < ActiveRecord::Base
  belongs_to :track
  serialize :time, Tod::TimeOfDay

  def day_of_week_name
    (I18n.t :'date.day_names')[self.day_of_week % 7]
  end

  def time_h_m
    self.time.strftime('%H:%M')
  end
end
