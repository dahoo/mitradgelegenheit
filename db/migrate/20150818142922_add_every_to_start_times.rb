class AddEveryToStartTimes < ActiveRecord::Migration
  def change
    add_column :start_times, :every, :integer, default: 1
  end
end
