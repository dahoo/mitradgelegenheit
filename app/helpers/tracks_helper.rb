module TracksHelper
  def days_of_week_names(short: false)
    names = if short
              I18n.t(:'date.abbr_day_names').clone
            else
              I18n.t(:'date.day_names').clone
            end
    names.push names.shift
    names.map.with_index.to_a
  end

  def track_categories
    {'Arbeit/Schule/Uni' => 'commute', 'Freizeit' => 'leisure', 'Event' => 'event', 'Sonstiges' => 'other'}
  end
end
