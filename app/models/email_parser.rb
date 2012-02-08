class EmailParser < ActiveRecord::Base
  # To change this template, choose Tools | Templates
  # and open the template in the editor.

  require 'net/imap'
  require 'tmail'

  def self.check_inbound

    imap = Net::IMAP.new('secure.emailsrvr.com')
    imap.login('study@blognogresearch.com', 'masterkey')
    imap.select('INBOX')
    imap.search(["NOT", "DELETED"]).each do |message_id|
      msg = imap.fetch(message_id,'RFC822')[0].attr['RFC822']
      mail = TMail::Mail.parse(msg)
      body = mail.body
      subject = mail.subject
      from = mail.from
      @emailing_user = User.find(:last, :conditions => {:login => subject})

      if @emailing_user
        comment = Comment.new()
        comment.comment = body
        comment.user_id = @emailing_user.id
        if ! mail.attachments.blank?
          comment.photo = mail.attachments.first
        end
        comment.emailed = true
        comment.save(false)
      else
        UserMailer.deliver_not_found(from, subject)
      end
      imap.store(message_id, "+FLAGS", [:Deleted])
    end
    imap.expunge()
  end
end
