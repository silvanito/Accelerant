class AddHeatmapTypeToDiscussions < ActiveRecord::Migration
  def self.up
    add_column :discussions, :heatmap_type_id, :integer
  end

  def self.down
    remove_column :discussions, :heatmap_type_id
  end
end
