class AddDateToStartTimes < ActiveRecord::Migration
  def change
    add_column :start_times, :date, :date
  end
end
