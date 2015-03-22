class AddIsRepeatedToStartTimes < ActiveRecord::Migration
  def change
    add_column :start_times, :is_repeated, :boolean
  end
end
