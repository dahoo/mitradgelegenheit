class Track < ActiveRecord::Base
  has_many :track_points, dependent: :destroy
  has_many :starts, dependent: :destroy
  has_many :ends, dependent: :destroy

  validates :name, :time, presence: true

  def points_list
    self.track_points.map{ |p| [p.latitude, p.longitude] }
  end
end
