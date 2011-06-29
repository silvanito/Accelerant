class AddCommentTypeToDiscussions < ActiveRecord::Migration
  def self.up
    add_column :discussions, :comment_type, :string
  end

  def self.down
    remove_column :discussions, :comment_type
  end
end
