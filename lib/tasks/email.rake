require 'active_record'
require 'active_record/fixtures'
require 'net/imap'
require 'tmail'

namespace :email do
  task :check => :environment do
    imap = Net::IMAP.new('secure.emailsrvr.com')
    imap.login('study@blognogresearch.com', 'masterkey')
    imap.select('INBOX')
    imap.search(["NOT", "DELETED"]).each do |message_id|
      msg = imap.fetch(message_id, 'RFC822')[0].attr['RFC822']
      mail = TMail::Mail.parse(msg)
      body = mail.body

      subject = mail.subject.to_s.strip.downcase
      from = mail.from
      puts from
      user = User.find(:all, :conditions => ["login = ?", subject]).first
      if user
        puts "user found"
        comment = Comment.new()
        comment.comment = body

        comment.user_id = user.id
        if ! mail.attachments.blank?
          comment.photo = mail.attachments.first
        end #end if
        puts comment.save(false)

      else
        UserMailer.deliver_not_found(from, subject)
        puts "not found"
      end# end if 
      imap.store(message_id, "+FLAGS", [:Deleted])
    end #end each
    imap.expunge()
	end #end task 
end# end name space