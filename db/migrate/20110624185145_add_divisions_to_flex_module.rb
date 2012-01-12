class AddDivisionsToFlexModule < ActiveRecord::Migration
  def self.up
    add_column :flex_modules, :divisions, :integer
  end

  def self.down
    remove_column :flex_modules, :divisions
  end
end
