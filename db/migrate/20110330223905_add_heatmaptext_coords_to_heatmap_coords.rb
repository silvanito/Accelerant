class AddHeatmaptextCoordsToHeatmapCoords < ActiveRecord::Migration
  def self.up
    add_column :heatmap_coords, :startX    ,  :float
    add_column :heatmap_coords, :startY    ,  :float
    add_column :heatmap_coords, :endX      ,  :float
    add_column :heatmap_coords, :lineHeight,  :float
  end

  def self.down
    remove_column :heatmap_coords, :startX
    remove_column :heatmap_coords, :startY
    remove_column :heatmap_coords, :endX
    remove_column :heatmap_coords, :lineHeight
  end
end
