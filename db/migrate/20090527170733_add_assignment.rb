class AddAssignment < ActiveRecord::Migration
  def self.up
    add_column :comments, :assignment_id, :integer
  end

  def self.down
      remove_column :comments, :assignment_id
  end
end
