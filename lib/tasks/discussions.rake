require 'active_record'
require 'active_record/fixtures'

namespace :discussions do
  desc 'change for report column of all comments '
  task :change_category_id => :environment do 
    @discussions = Discussion.all
    @discussions.each do |discussion|
      discussion.category_id = nil
      discussion.save
    end
  end

  desc 'Set comment_type to public in all discussions'
  task :set_comment_type_to_public => :environment do
    @discussions = Discussion.all
    @discussions.each do |discussion|
      discussion.comment_type = "public"
      discussion.save
    end
  end
end
