class AddCategoryToTracks < ActiveRecord::Migration
  def change
    add_column :tracks, :category, :string
  end
end
