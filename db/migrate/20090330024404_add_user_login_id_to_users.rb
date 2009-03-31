class AddUserLoginIdToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :user_login_id, :integer
  end

  def self.down
    remove_column :users, :user_login_id
  end
end
