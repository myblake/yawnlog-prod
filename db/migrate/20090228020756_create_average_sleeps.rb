class CreateAverageSleeps < ActiveRecord::Migration
  def self.up
    create_table :average_sleeps do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :average_sleeps
  end
end
