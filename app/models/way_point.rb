# == Schema Information
#
# Table name: way_points
#
#  id          :integer          not null, primary key
#  track_id    :integer
#  latitude    :float            not null
#  longitude   :float            not null
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

class WayPoint < ActiveRecord::Base
  belongs_to :track

  validates :latitude, :longitude, presence: true

  default_scope { order :time }
end
