require 'active_record'
require 'active_record/fixtures'

desc 'add heatmap type to heatmaps'
task :heatmaptypes => :environment do 
  discussions = Discussion.find(:all, :conditions => {:has_heatmap => true})
  discussions.each do |discussion|
    discussion.heatmap_type_id = 1
    discussion.save
  end
end
