require 'active_record'
require 'active_record/fixtures'

desc 'All themes has one owner => admin '
task :themes => :environment do |t|
  themes = Theme.all
  admin = User.find(:first, :conditions => {:admin => true})
  themes.each do |theme|
    theme.owner = admin.id
    theme.save
  end
end
