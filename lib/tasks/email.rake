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
      msg = imap.fetch(message_id,'RFC822')[0].attr['RFC822']
      mail = TMail::Mail.parse(msg)
      body = mail.body

      subject = mail.subject
      puts subject
      from = mail.from
      @emailing_user = User.find(:last, :conditions => {:login => subject})

      if @emailing_user
        puts "encontro al usuario"
        comment = Comment.new()
        comment.comment = body

        comment.user_id = @emailing_user.id
        if ! mail.attachments.blank?
          #File.open(mail.attachments.first.original_filename, 'rb') { |attachment| comment.photo = attachment }
          comment.photo = mail.attachments.first
          #comment.photo = mail.attachments.first.base64_decode!
        end #end if
        puts comment.save

      else
        UserMailer.deliver_not_found(from, subject)
      end# end if 
      imap.store(message_id, "+FLAGS", [:Deleted])
    end #end each
    imap.expunge()
	end #end task 
end# end name space