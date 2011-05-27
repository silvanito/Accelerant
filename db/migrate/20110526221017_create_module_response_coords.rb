class CreateModuleResponseCoords < ActiveRecord::Migration
  def self.up
    create_table :module_response_coords do |t|
      t.float :x_coord
      t.float :y_coord
      t.integer :module_response_id
      t.integer :module_image_id

      t.timestamps
    end
  end

  def self.down
    drop_table :module_response_coords
  end
end
