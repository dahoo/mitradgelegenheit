module TracksHelper
  def days_of_week_names(short: false)
    names = if short
              I18n.t(:'date.abbr_day_names').clone
            else
              I18n.t(:'date.day_names').clone
            end
    names.push names.shift
    names = names.map.with_index.to_a
    names += special_days_of_week_names.invert.to_a
  end

  def special_days_of_week_names
    {10 => 'täglich', 11 => 'Mo.-Fr.', 12 => 'Sa., So.'}
  end

  def every_names
    {'jeden' => 1, 'jeden 2.' => 2, 'jeden 3.' => 3, 'jeden 4.' => 4,
      'jeden 1. im Monat' => 11, 'jeden 2. im Monat' => 12,
      'jeden 3. im Monat' => 13, 'jeden 4. im Monat' => 14,
      'jeden letzten im Monat' => -1}
  end

  def every_names_inline(day)
    {"jeden #{day}" => 1, "jeden 2. #{day}" => 2, "jeden 3. #{day}" => 3, "jeden 4. #{day}" => 4,
      "jeden ersten #{day} im Monat" => 11, "jeden zweiten #{day} im Monat" => 12,
      "jeden dritten #{day} im Monat" => 13, "jeden vierten #{day} im Monat" => 14,
      "jeden letzten #{day} im Monat" => -1}
  end

  def track_categories
    {'Arbeit/Schule/Uni' => 'commute', 'Freizeit' => 'leisure', 'Event' => 'event', 'Sonstiges' => 'other'}
  end
end
