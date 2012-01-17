require 'active_record'
require 'active_record/fixtures'

namespace :fix_encoding do
  task :comments => :environment do
    Comment.all.each do |c|
      unless c.discussion.nil? 
        c.comment = Iconv.conv("ASCII//IGNORE", "UTF-8", c.comment) + ' '
        c.save
      end
    end
    puts 'Comments ... done '
  end
end