class CreateTracks < ActiveRecord::Migration
  def change
    create_table :tracks do |t|
      t.string :name
      t.float :distance
      t.string :time
      t.string :link

      t.timestamps
    end
  end
end
