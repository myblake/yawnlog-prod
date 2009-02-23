class CreateSleeps < ActiveRecord::Migration
  def self.up
    create_table :sleeps do |t|
      t.datetime :start
      t.datetime :stop
      
      t.integer :user_id #foreign key

      t.timestamps
    end
  end

  def self.down
    drop_table :sleeps
  end
end
