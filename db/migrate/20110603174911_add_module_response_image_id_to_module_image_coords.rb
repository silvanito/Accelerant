class AddModuleResponseImageIdToModuleImageCoords < ActiveRecord::Migration
  def self.up
    add_column :module_image_coords, :module_response_image_id, :integer
  end

  def self.down
    remove_column :module_image_coords, :module_response_image_id
  end
end
