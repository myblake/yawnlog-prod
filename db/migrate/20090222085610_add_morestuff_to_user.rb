class AddMorestuffToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :target_hours, :decimal
    add_column :users, :twitter, :string
  end

  def self.down
    remove_column :users, :twitter
    remove_column :users, :target_hours
  end
end
