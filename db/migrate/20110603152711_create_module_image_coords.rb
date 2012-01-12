class CreateModuleImageCoords < ActiveRecord::Migration
  def self.up
    create_table :module_image_coords do |t|
      t.float  :xCoord
      t.float  :yCoord
      t.integer :module_image_id

      t.timestamps
    end
  end

  def self.down
    drop_table :module_image_coords
  end
end
