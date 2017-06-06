# == Schema Information
#
# Table name: track_points
#
#  id         :integer          not null, primary key
#  track_id   :integer
#  latitude   :float
#  longitude  :float
#  index      :integer
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_track_points_on_track_id  (track_id)
#

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
