class AddModuleImageCoordIdToComments < ActiveRecord::Migration
  def self.up
    add_column :comments, :module_image_coord_id, :integer
  end

  def self.down
    remove_column :comments, :module_image_coord_id
  end
end
