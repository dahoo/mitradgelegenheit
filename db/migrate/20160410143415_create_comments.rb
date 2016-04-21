class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.belongs_to :user, index: true
      t.belongs_to :track, index: true
      t.text :text

      t.timestamps
    end
  end
end
