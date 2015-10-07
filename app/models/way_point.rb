class WayPoint < ActiveRecord::Base
  belongs_to :track

  default_scope { order :time }
end
