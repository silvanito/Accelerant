require 'active_record'
require 'active_record/fixtures'

desc 'setup flex_module status to drafted'
task :flex_modules_status => :environment do |t|
  @flex_modules= FlexModule.all
  @flex_modules.each do |flex_module|
    flex_module.status = "draft"
    flex_module.save
  end
end
