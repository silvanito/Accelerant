class ChangeColumnImageresultOfHeatmaps < ActiveRecord::Migration
  def self.up
    change_column(:heatmaps, :image_result, :binary, :size => 2.megabyte)
  end

  def self.down
    change_column(:heatmaps, :image_result, :binary)
  end
end
