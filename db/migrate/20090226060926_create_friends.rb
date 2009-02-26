class CreateFriends < ActiveRecord::Migration
  def self.up
    create_table :friends do |t|
      t.integer :user_id_1
      t.integer :user_id_2
      t.boolean :accepted
      t.boolean :rejected
      t.timestamps
    end
  end

  def self.down
    drop_table :friends
  end
end
