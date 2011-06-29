class AddPositionRankToModuleImageCoords < ActiveRecord::Migration
  def self.up
    add_column :module_image_coords, :position_rank, :integer
  end

  def self.down
    remove_column :module_image_coords, :position_rank
  end
end
