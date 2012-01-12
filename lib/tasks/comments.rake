require 'active_record'
require 'active_record/fixtures'

desc 'change for report column of all comments '
task :comments => :environment do |t|
  @comments = Comment.all
  @comments.each do |comment|
    comment.for_report = 0
    comment.save
  end
end
