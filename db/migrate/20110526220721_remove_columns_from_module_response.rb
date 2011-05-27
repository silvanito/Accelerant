class RemoveColumnsFromModuleResponse < ActiveRecord::Migration
  def self.up
    remove_column(:module_responses, :x_coord)
    remove_column(:module_responses, :y_coord)
    remove_column(:module_responses, :module_image_id)
  end

  def self.down
    add_column(:module_responses, :x_coord, :float)
    add_column(:module_responses, :y_coord, :float)
    add_column(:module_responses, :module_image_id, :integer)
  end
end
