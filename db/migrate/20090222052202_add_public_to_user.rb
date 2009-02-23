class AddPublicToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :public_profile, :boolean
    add_column :users, :zip, :string,
      :min => 5, :max => 5
  end

  def self.down
    remove_column :users, :public_profile
    remove_column :users, :zip
  end
end
