class EmailerController < ApplicationController

  layout 'plain'
  require 'net/imap'
  require 'tmail'

  
  def index


#UserMailer.check_mail
#UserMailer.deliver_test_email()
imap = Net::IMAP.new('secure.emailsrvr.com')
imap.login('study@blognogresearch.com', 'masterkey')
imap.select('INBOX')
imap.search(["NOT", "DELETED"]).each do |message_id|
msg = imap.fetch(message_id,'RFC822')[0].attr['RFC822']
mail = TMail::Mail.parse(msg)

#body = mail.body
if mail.body_plain.nil?
  body = mail.body_html
else
  body = mail.body_plain
end

subject = mail.subject
from = mail.from

@emailing_user = User.find(:last, :conditions => {:login => subject})

if @emailing_user


  comment = Comment.new()
  comment.comment = body
  comment.user_id = @emailing_user.id
  if ! mail.attachments.blank?
    #File.open(mail.attachments.first.original_filename, 'rb') { |attachment| comment.photo = attachment }
    comment.photo = mail.attachments.first
    #comment.photo = mail.attachments.first.base64_decode!
  end
  comment.save(false)

else
UserMailer.deliver_not_found(from, subject)
end


imap.store(message_id, "+FLAGS", [:Deleted])
end
imap.expunge()

  end

end
