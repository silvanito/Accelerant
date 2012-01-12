class AddLabelColumnsToFlexModules < ActiveRecord::Migration
  def self.up
    add_column :flex_modules, :top_label, :string
    add_column :flex_modules, :right_label, :string
    add_column :flex_modules, :bottom_label, :string
    add_column :flex_modules, :left_label, :string
  end

  def self.down
    remove_column :flex_modules, :top_label
    remove_column :flex_modules, :right_label
    remove_column :flex_modules, :bottom_label
    remove_column :flex_modules, :left_label
  end
end
