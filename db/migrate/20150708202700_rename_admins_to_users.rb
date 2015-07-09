class RenameAdminsToUsers < ActiveRecord::Migration
  def change
    rename_table :admins, :users
    add_column :users, :admin, :boolean, default: false, null: false
    add_column :users, :name, :string, default: 'User', null: false
  end
end
