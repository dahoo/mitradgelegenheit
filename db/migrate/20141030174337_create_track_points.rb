class CreateTrackPoints < ActiveRecord::Migration
  def change
    create_table :track_points do |t|
      t.belongs_to :track, index: true
      t.float :latitude
      t.float :longitude
      t.integer :index

      t.timestamps
    end
  end
end
