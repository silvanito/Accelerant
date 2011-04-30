require 'active_record'
require 'active_record/fixtures'

desc 'change category_id of all discussions '
task :discussions => :environment do |t|
  @discussions = Discussion.all
  @discussions.each do |discussion|
    discussion.category_id = nil
    discussion.save
  end
end
