class AddUserIdToTracks < ActiveRecord::Migration
  def change
    add_reference :tracks, :user, index: true
  end
end
