class AddPwResetToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :pw_reset, :boolean
  end

  def self.down
    remove_column :users, :pw_reset
  end
end
