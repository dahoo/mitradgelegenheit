class AddIndexesToWayPoints < ActiveRecord::Migration
  def change
    add_index :way_points, [:id, :type]
  end
end
