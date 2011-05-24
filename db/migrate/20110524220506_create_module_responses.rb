class CreateModuleResponses < ActiveRecord::Migration
  def self.up
    create_table :module_responses do |t|
      t.integer :module_id
      t.integer :module_image_id  
      t.integer :comment_id
      t.float :x_coord
      t.float :y_coord
      t.timestamps
    end
  end

  def self.down
    drop_table :module_responses
  end
end
