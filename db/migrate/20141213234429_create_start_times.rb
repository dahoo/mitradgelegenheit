class CreateStartTimes < ActiveRecord::Migration
  def change
    create_table :start_times do |t|
      t.integer :day_of_week
      t.time :time
      t.belongs_to :track, index: true

      t.timestamps
    end
  end
end
