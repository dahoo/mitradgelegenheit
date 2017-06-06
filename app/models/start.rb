# == Schema Information
#
# Table name: way_points
#
#  id          :integer          not null, primary key
#  track_id    :integer
#  latitude    :float
#  longitude   :float
#  description :string(255)
#  type        :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  time        :integer          default(0)
#
# Indexes
#
#  index_way_points_on_id_and_type  (id,type)
#  index_way_points_on_track_id     (track_id)
#

class Start < WayPoint
  def index
    track.starts.index(self).try(:+, 1) if track
  end
end
