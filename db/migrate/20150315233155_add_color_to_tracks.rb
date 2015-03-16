class AddColorToTracks < ActiveRecord::Migration
  def change
    add_column :tracks, :color_index, :integer
  end
end
