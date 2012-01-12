class AddForReportToReplies < ActiveRecord::Migration
  def self.up
    add_column :replies, :for_report, :integer
  end

  def self.down
    remove_column :replies, :for_report
  end
end
