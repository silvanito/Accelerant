class AddHeatmapSizeToDiscussion < ActiveRecord::Migration
  def self.up
    add_column :discussions, :width, :float
    add_column :discussions, :height, :float
  end

  def self.down
    remove_column :discussions, :width
    remove_column :discussions, :height
  end
end
