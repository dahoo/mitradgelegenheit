class WayPoint < ActiveRecord::Base
  belongs_to :track

  default_scope { order :created_at }
end
