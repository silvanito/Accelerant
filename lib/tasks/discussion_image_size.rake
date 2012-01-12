require 'active_record'
require 'active_record/fixtures'

desc 'change category_id of all discussions '
task :discussion_image_size => :environment do |t|
  @projects= Project.all
  @projects.each do |project|
    project.image_size = "small"
    project.save
  end
end
