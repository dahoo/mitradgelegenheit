class RenameAdminsToUsers < ActiveRecord::Migration
  def up
    change_users
    change_column_default :users, :name, ''
  end

  def down
    revert { change_users }
  end

  def change_users
    rename_table :admins, :users
    add_column :users, :admin, :boolean, default: false, null: false
    add_column :users, :name, :string, default: 'User', null: false
  end
end
