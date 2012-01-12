class CreateHeatmapTypes < ActiveRecord::Migration
  def self.up
    create_table :heatmap_types do |t|
      t.column :heatmap_type, :string
      t.timestamps
    end
  end

  def self.down
    drop_table :heatmap_types
  end
end
