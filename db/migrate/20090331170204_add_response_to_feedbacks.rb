class AddResponseToFeedbacks < ActiveRecord::Migration
  def self.up
    add_column :feedbacks, :response, :string
  end

  def self.down
    remove_column :feedbacks, :response
  end
end
