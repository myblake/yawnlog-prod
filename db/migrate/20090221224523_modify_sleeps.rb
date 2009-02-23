class ModifySleeps < ActiveRecord::Migration
  def self.up
    add_column :sleeps, :zip, :string,
      :min => 5, :max => 5
    add_column :sleeps, :quality, :integer
    add_column :sleeps, :note, :string
  end

  def self.down
    remove_column :sleeps, :quality
    remove_column :sleeps, :zip
    remove_column :sleeps, :note
  end
end
