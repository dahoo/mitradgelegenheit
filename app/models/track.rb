class Track < ActiveRecord::Base
  has_many :track_points, dependent: :destroy, autosave: true
  has_many :starts, dependent: :destroy, autosave: true
  has_many :ends, dependent: :destroy, autosave: true
  has_many :start_times, dependent: :destroy, autosave: true

  accepts_nested_attributes_for :start_times
  accepts_nested_attributes_for :starts
  accepts_nested_attributes_for :ends

  validates :name, presence: true

  def points_list
    track_points.map{ |p| [p.latitude, p.longitude] }
  end

  def start
    starts.order(:time).first
  end
end
