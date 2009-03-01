class AddUpdatedToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :last_login_at, :timestamp
    add_column :users, :last_sleep_at, :timestamp    
    add_column :users, :num_of_sleeps, :integer
  end

  def self.down
    remove_column :users, :last_login_at
    remove_column :users, :last_sleep_at
    remove_column :users, :num_of_sleeps
  end
end