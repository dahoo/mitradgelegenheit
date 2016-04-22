class Comment < ActiveRecord::Base
  belongs_to :track
  belongs_to :user

  validates :track, presence: true
  validates :user, presence: true
  validates :text, presence: true

  def user_name
    user.name
  end

  def track_name
    track.name
  end
end
