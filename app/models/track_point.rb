class TrackPoint < ActiveRecord::Base
  belongs_to :track

  def to_coordinates
    [latitude, longitude]
  end
end
