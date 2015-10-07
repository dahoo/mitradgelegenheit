class AddDescriptionToTracks < ActiveRecord::Migration
  def change
    add_column :tracks, :description, :text, default: ''
  end
end
