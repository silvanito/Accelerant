class AddSubcommentIdToReportComments < ActiveRecord::Migration
  def self.up
    add_column :report_comments, :subcomment_id, :integer
  end

  def self.down
    remove_column :report_comments, :subcomment_id
  end
end
