class TrackPoint < ActiveRecord::Base
  belongs_to :track

  default_scope { order(:index) }

  before_save :increase_index

  def to_coordinates
    [latitude, longitude]
  end

  def increase_index
    return unless index.nil?
    self.index = track.track_points.pluck(:index).max + 1
  end
end
