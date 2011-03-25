require 'active_record'
require 'active_record/fixtures'

desc 'change for report column of all comments '
task :replies => :environment do |t|
  @replies = Replies.all
  @replies.each do |reply|
    reply.for_report = 0
    reply.save
  end
end
