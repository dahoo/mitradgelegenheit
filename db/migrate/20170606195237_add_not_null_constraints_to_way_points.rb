class AddNotNullConstraintsToWayPoints < ActiveRecord::Migration
  def change
    change_column_null :way_points, :latitude, false
    change_column_null :way_points, :longitude, false
  end
end
