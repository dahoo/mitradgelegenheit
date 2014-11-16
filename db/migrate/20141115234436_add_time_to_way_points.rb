class AddTimeToWayPoints < ActiveRecord::Migration
  def change
    add_column :way_points, :time, :integer
  end
end
