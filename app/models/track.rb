# == Schema Information
#
# Table name: tracks
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  distance    :float
#  time        :string(255)
#  link        :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  color_index :integer
#  user_id     :integer
#  category    :string(255)
#  description :text             default("")
#
# Indexes
#
#  index_tracks_on_user_id  (user_id)
#

class Track < ActiveRecord::Base
  include TracksHelper

  belongs_to :user
  has_many :track_points, dependent: :destroy, autosave: true
  has_many :starts, dependent: :destroy, autosave: true
  has_many :ends, dependent: :destroy, autosave: true
  has_many :start_times, dependent: :destroy, autosave: true
  has_many :comments

  scope :active, -> { joins { start_times }.where { (start_times.date == nil) | (start_times.date >= Date.today) }.group { id } }
  scope :by_created_at, -> { order :created_at }

  after_initialize :init

  accepts_nested_attributes_for :start_times, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :starts, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :ends, reject_if: :all_blank, allow_destroy: true

  def self.categories
    %w(commute leisure event other)
  end

  validates :name, presence: true
  validates :category, inclusion: {in: Track.categories}
  validates :name, :link, :category, length: { maximum: 255 }

  attr_reader :points

  def init
    self.color_index ||= rand * Track.colors.size
  end

  def points_list
    track_points.map(&:to_coordinates)
  end

  def start
    starts.order(:time).first
  end

  def color
    Track.colors[Track.categories.index(category) % Track.colors.size]
  end

  def self.colors
    ['#334D5C', '#45B29D', '#FFC300', '#E27A3F', '#DF4949']
  end

  def compute_length
    sum = 0.0
    points_list.each_with_index do |coord, i|
      next if i == 0
      sum += Geocoder::Calculations.distance_between(points_list[i - 1], coord)
    end
    update_column :distance, sum
  end

  def add_track_points(track_point_params)
    track_points.delete_all
    on_points(track_point_params) {|point| track_points.create! point }
    compute_length
  end

  def on_points(points)
    points.split(';').each_with_index do |point, i|
      point = point.split(',')
      yield latitude: point[0].to_f,
            longitude: point[1].to_f,
            index: i
    end
  end

  def next_occurence
    start_times.map(&:next_occurence).min
  end

  def next_occurences_in_days(days)
    start_times.map {|st| st.next_occurences_in_days(days) }.flatten
  end

  def self.options_for_category
    track_categories
  end
end
