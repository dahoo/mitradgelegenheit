class Track < ActiveRecord::Base
  has_many :track_points, dependent: :destroy, autosave: true
  has_many :starts, dependent: :destroy, autosave: true
  has_many :ends, dependent: :destroy, autosave: true
  has_many :start_times, dependent: :destroy, autosave: true

  validates :name, presence: true

  def points_list
    self.track_points.map{ |p| [p.latitude, p.longitude] }
  end

  def start
    self.starts.order(:time).first
  end
end
