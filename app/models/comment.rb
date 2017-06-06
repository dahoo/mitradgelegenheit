# == Schema Information
#
# Table name: comments
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  track_id   :integer
#  text       :text
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_comments_on_track_id  (track_id)
#  index_comments_on_user_id   (user_id)
#

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
