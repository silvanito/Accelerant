module RepliesHelper
  def render_reply(replies)
    if  replies.for_report == 1
      reply_style = "background-color:#A7C8DF;"
    else
      reply_style = "background-color:#CDD7DE;"
    end
    output = "<div id='reply#{replies.id}' class='replyStyle' style='#{reply_style}'>"

    output = output + render_small_avatar(replies.user)
    output = output + "&nbsp;&nbsp;"
    #output = output + replies.content.gsub(/<\/?[^>]*>/,  "")
    unless client_browser_name == "Internet Explorer"
      output = output + "<div class='replyText'>"
    end
    output = output + replies.content
    unless client_browser_name == "Internet Explorer"
      output = output + "</div>"
    end
    #output = output + simple_format(replies.content)
    #output = output + simple_format(Remo.new(replies.content).to_html)

		if replies.media_file_name
      if replies.media_content_type =~ /image.*/
        #output = output + "<a href='#{replies.media.url}' class='MagicThumb' rel='buttons:hide' target='_blank'>"
        output = output + "<p>Image: </p><br/>"
        output = output + "<a href='#{replies.media.url}' target='_blank'>"
        output = output + image_tag(replies.media.url(self.current_project.image_size.to_sym), :style => 'margin-left:1px;')
        output = output + "</a>"
			else
        output = output + "<a href='#{replies.media.url}' target='_blank'>View attached file here.</a>"
        output = output + image_tag("download.png")
			end
		end
    output = output + "<br/>"
		output = output + " posted by "
    if replies.user.name == self.current_user.name
       output = output + "you "
		else
			output = output + replies.user.name + " "
		end
		output = output + time_ago_in_words(replies.created_at)
    output = output + " ago"
    unless @project.lock
      if (replies.user.id == self.current_user.id) || self.current_user.admin

        output = output + " | "
        output = output + link_to_remote("Delete",
					:confirm => "Are you sure you want to delete this?",
					:url => {:controller => 'plain', :action => 'drop_reply', :id => replies.id},
					:complete => "new Effect.Fade('reply#{replies.id}', { duration: 2 })",
					:update => "reply#{replies.id}")
      end
      if (self.current_user.admin || self.current_user.moderator)
        output = output + " | "
        output = output + link_to_remote("Probe",
					:url => {:controller => 'plain', :action => 'follow_up', :id => replies.id},
					:update => "probe#{replies.id}")
      end
      comment = Comment.find(replies.comment_id)
      if ((self.current_user.admin || self.current_user.moderator || self.current_user.client) && (replies.user.participant? == true) )
        if replies.for_report == 0
          status = false
        else
          status = true
        end
        if comment.user.admin || comment.user.moderator
         reply_status = "display:inline"
        elsif comment.for_report == 1 && comment.user.participant
         reply_status = "display:inline"
        else
         reply_status = "display:none;"
        end
        output = output + "<label id='label_#{replies.id}' for='replies_#{replies.id}' style='#{reply_status}'> | TAG </label> "
        output = output + check_box_tag("replies_#{replies.id}",replies.id, status, 
      :onclick => remote_function( 
      :url => {:controller => :replies, :action => :add_to_report}, 
      :with => "'id='+#{replies.id}",
      404 => "alert('Not found...? Wrong URL...?')",
      :failure => "alert('HTTP Error ' + request.status + '!')",
      :complete => "if(request.responseText == 'added'){ new Effect.SlideDown('reply#{replies.id}', {duration: 0.4 });new Effect.Morph('reply#{replies.id}', {  style: 'background-color:#A7C8DF;', duration: 0.3 });}else{new Effect.SlideDown('reply#{replies.id}', {duration: 0.4 }); new Effect.Morph('reply#{replies.id}', {  style: 'background-color:#CDD7DE;', duration: 0.5 });}" ), :style => reply_status)
        if replies.for_report == 0
          output = output + "<div id='report_subcomments_#{replies.id}'> </div>"
        else
          output = output + "<div  id='report_subcomments_#{replies.id}'>"
          @report_comments = ReportComment.find(:all, :conditions=>{:subcomment_id => replies.id}) 
          
          output = output + render(:partial => "report_comments/index", :locals => {:comment_id => nil, :subcomment_id => replies.id})
          output = output + "</div>"
        end
      end
    end
    if (self.current_user.admin || self.current_user.moderator || (self.current_user.id == replies.user_id) || self.current_user.client )
      @follows = FollowUps.find(:all, :conditions => {:reply_id => replies.id}, :order => "id ASC")
      @follows_last = FollowUps.find(:last, :conditions => {:reply_id => replies.id}, :order => "id ASC")
    else
      @follows = FollowUps.find(:all, :conditions => "1 = 0")
    end
    output = output + "<div id='probe#{replies.id}'></div>"
    for follows in @follows
      output = output + render_probe(follows,replies)
    end
    #output = output + "<div id='probe#{replies.id}'></div>"
    output = output + "<br/>"
    output = output + "</div> <!-- end reply -->"
    return output
    
  end

  def render_reply_standalone(replies)
    output = "<div id='reply#{replies.id}' style='background-color:#cdd7de;margin:8px;padding:2px;'>"

    output = output + render_small_avatar(replies.user)
    output = output + "&nbsp;&nbsp;"
    output = output + simple_format(replies.content)
		if replies.media_file_name
      if replies.media_content_type =~ /image.*/
        output = output + "<a href='#{replies.media.url}' target='_blank'>"
        output = output + image_tag(replies.media.url(:small), :style => 'margin-left:1px;')
        output = output + "</a>"
			else
        output = output + "<a href='#{replies.media.url}' target='_blank'>View attached file here.</a>"
        output = output + image_tag("download.png")
			end
		end
		output = output + " posted by "
    if replies.user.name == self.current_user.name
       output = output + "you "
		else
			output = output + replies.user.name + " "
		end
		output = output + time_ago_in_words(replies.created_at)
    output = output + " ago"

    output = output + "<br/><br/>"
    output = output + "</div> <!-- end reply -->"
    return output
  end
end
