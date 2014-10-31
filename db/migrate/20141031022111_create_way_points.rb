class CreateWayPoints < ActiveRecord::Migration
  def change
    create_table :way_points do |t|
      t.belongs_to :track, index: true
      t.float :latitude
      t.float :longitude
      t.string :description
      t.string :type

      t.timestamps
    end
  end
end
