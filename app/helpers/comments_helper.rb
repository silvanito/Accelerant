module CommentsHelper

  def show_comment(comment, report = false)
    if comment.hide_until_answered && self.current_user.participant
      @reply_test = Replies.find(:all, :conditions => {:comment_id => comment.id, :user_id => self.current_user.id}, :include => :user)
      if @reply_test.empty?
        suppress = true
      end
    end
    out = "<div class='clientSubComment commentSub#{@comment_number}' id='commentSub#{comment.id}'><div id='commentSub#{@comment_number}'></div>"
    out = out + "<div class='subCommentAvatar'>"
    out = out + render_avatar(comment.user)
    out = out + "</div>"

    out = out + "<div class='clientSubCommentText' >"
		out = out + "<p>"

		out = out + "<strong><em>"
    out = out + comment.user.name
    out = out + " says:</em></strong>"
    out = out + "</div><br />"
    unless client_browser_name == "Internet Explorer"
      out = out + "<div class='commentText'>"
    end
		#out = out + Remo.new(comment.comment).to_html
    #out = out + comment.comment.gsub(/<\/?[^>]*>/,  "")
    if comment.emailed
      out = out + comment.comment.gsub(/<\/?[^>]*>/,  "")
    else
      out = out + comment.comment
    end
    unless client_browser_name == "Internet Explorer"
      out = out + "</div>"
    end
    #out = out + comment.comment
		if comment.photo_content_type
      if comment.photo_content_type =~ /image.*/
        #out = out + "<a href='#{comment.photo.url}' class='MagicThumb' rel='buttons:hide' target='_blank' >"
        out = out + link_to(image_tag(comment.photo.url(:thumb), :style => 'margin-left:1px;'), :controller => "comments", :action => "show_image", :id => comment.id)
      else
        out = out + "<p><a href='#{comment.photo.url}' target='_blank'>View attached file here.</a>"
        out = out + image_tag("download.png")
        out = out + "</p>"
      end
		end
		out = out + "<br/>"
		out = out + "<span>- Posted "
    out = out + time_ago_in_words(comment.created_at)
    out = out + " ago </span> <!-- #{comment.created_at}  -->"
    unless report
  		unless @project.lock 
        unless @comment_number >= @total_comments
          @next_comment = @comment_number + 1
        end
        if @total_comments == 0
          @next_comment = nil
        end
        if !self.current_user.client
          out = out + " | "
          out = out + link_to_remote('Add Comment',
            :url => { :controller => 'plain', :action => 'sub_form', :id => comment.id, :comment => @next_comment},
            :complete => "new Effect.SlideDown('subCommentForm#{comment.id}', { duration: .5 })",
            :update => "subCommentForm#{comment.id}", :loading => "$('respondercomment').removeClassName('rich_text_editor'); $('repliesResponder').removeClassName('rich_text_editor')")
        end
        if (comment.user.id == self.current_user.id) || self.current_user.admin
  				out = out + " | "
          out = out + link_to_remote("Edit",
            :url => {:controller => 'plain', :action => 'edit_comment', :id => comment.id},
            #:complete => "new Effect.SlideDown('commentSub#{comment.id}', { duration: .2 })",
            :complete => "new Effect.Parallel([new Effect.SlideDown('commentSub#{comment.id}', { duration: .2 }),
            new Effect.SlideUp('responder_form', { duration: .2 })
            ],{duration: 0.8,delay: 0.5})",
            :update => "commentSub#{comment.id}")
        end
        if (comment.user.id == self.current_user.id) || self.current_user.admin  || self.current_user.moderator
  				out = out + " | "
          out = out + link_to_remote("Delete",
            :confirm => "Are you sure you want to delete this?",
            :url => {:controller => 'plain', :action => 'drop_comment', :id => comment.id},
            :complete => "new Effect.Fade('commentSub#{comment.id}', { duration: 2 })",
            :update => "commentSub#{comment.id}")
        end

        if self.current_user.admin  || self.current_user.moderator
  				out = out + " | "
          out = out + link_to("Reorder",
            :controller => 'comments', :action => 'sort', :id => comment.discussion_id)
        end

        if ((self.current_user.admin || self.current_user.moderator || self.current_user.client) && (comment.user.participant? == true))
            if comment.for_report == 0
              status = false
            else
              status = true
            end
            out = out + "<label> | TAG </label>"
            out = out + check_box_tag("comment_#{comment.id}",comment.id, status, :onclick => remote_function(
          :url => {:controller => :comments, :action => :update_report_flag }, 
          :with => "'comment_id='+$('comment_#{comment.id}').value", 
          :complete => "new Effect.SlideDown('report_comments_#{comment.id}', { duration: .5 })" ))
          if comment.for_report == 0
            out = out + "<div id='report_comments_#{comment.id}'> </div>"
          else
            out = out + "<div  id='report_comments_#{comment.id}'>"
            @report_comments = ReportComment.find(:all, :conditions=>{:comment_id => comment.id})
            out = out + render(:partial => "report_comments/index", :locals => {:comment_id => comment.id})
            out = out + "</div>"
          end
        end
      end
    end
		out = out + "<div id='subCommentForm#{comment.id}' class='replyStyle' style='display:none;'></div>"
		out = out + "<div id='reclaimer#{comment.id}'></div>"
    if suppress
      @replies = Replies.find(:all, :conditions => "1 = 2")
    else
      @replies = Replies.find(:all, :conditions => { :comment_id => comment.id}, :order => "id ASC", :include => :user)
    end
    displayflag = true
    for replies in @replies
      if cookies[:filter] == "yes" && !self.current_user.participant
        displayflag = false

        cookies.to_hash.each_pair do |k, v|
          if cookies[k.to_sym].split('_')[0] == "field"
            #puts "start"
            #puts cookies[k.to_sym]  #e.g. "field_10"
            #puts k                  #e.g. "male"
            #puts "stop"
            #if replies.user.send(cookies[k.to_sym]) == k  #e.g. if user.field_10 == "male"
              #displayflag = true
            #end
            testuser = User.find_by_id(replies.user.id,:conditions => cookies[:sql])

            if testuser.nil?
              if !User.is_participant.find_by_id(replies.user.id)
                displayflag = true
              else
                displayflag = false
              end
              #puts "no match"
            else
              displayflag = true
              #puts "match"
            end
          end
          if cookies[:report] == "true" && !self.current_user.participant
            #@replies = Replies.find(:all, :conditions => {:comment_id => comment.id, :for_report => 1})
            if replies.for_report == 1
              displayflag = true
            else
              displayflag = false
            end
          end

        end
      end

      if displayflag && User.exists?(replies.user_id)
        if (!@project.one_to_one && discussion_subcomment_type(replies) ) || ((replies.user.id == self.current_user.id || replies.user.admin? || replies.user.moderator?) || self.current_user.admin? || self.current_user.moderator? || self.current_user.client? )
          out = out + render_reply(replies)
        end
      end
		end
    image = heatmap_screen_by_comment(comment.id)
		out = out + "<div id='#{dom_id(comment)}'>"
		out = out + "</div>"
    out = out + "<a name='subCommentForm#{comment.id}' ></a>"
    #out = out + "<div id='subCommentForm#{comment.id}' class='replyStyle' style='display:none;'></div>"

    
    unless image.blank?
      out = out + "<div class='heatmap'>"
      out = out + "<img src='#{image}' width =440 height =310/>"
      out = out + "</div>"
    end

    unless comment.discussion.flex_modules.empty?
      if current_user.admin? or current_user.moderator? or current_user.client? 
        out = out + "<div class='flex_modules'>"
        module_image = module_response_by_comment(comment)
        unless module_image.nil? 
          out = out + "<img src='#{module_image}'/>"
        end
        out = out + "</div>"
      end 
    end
		out = out + "<hr noshade='noshade'/>"
    #out = out + "<br/>"
    out = out +  "</div>"
    return out
  end

  def heatmap_screen_by_comment(comment_id)
    comment = Comment.find(comment_id)
    heatmap = Heatmap.find(:last, :conditions => {:user_id =>  comment.user_id, :comment_id =>  comment.id})
    if heatmap
      ""  #      heatmap.create_tmp_image
    else
      ""
    end
  end

  def discussion_comment_type(comment)
    discussion = comment.discussion unless comment.nil?
    if !discussion.flex_modules.empty? || discussion.has_heatmap || !comment.nil?
      case discussion.comment_type.to_sym
        when :public
         true
        when :private
         if self.current_user.participant 
          if comment.user_id == self.current_user.id
            true
          elsif comment.user.admin? || comment.user.moderator?
            true
          else
            false
          end
         else
          true
         end
        when :private_then_public
          if self.current_user.participant 
            last_comment = Comment.find(:last, :conditions => {:discussion_id => discussion.id, :user_id => self.current_user.id}) 
            if last_comment
              true
            elsif comment.user.admin? || comment.user.moderator?
              true
            else
              false
            end
          else
            true
          end
        end
    else
      false
    end
  end

  def discussion_subcomment_type(subcomment)
    discussion = subcomment.discussion unless subcomment.nil?
    unless subcomment.nil?
      case discussion.comment_type.to_sym
        when :public
         true
        when :private
         if self.current_user.participant 
            if subcomment.user_id == self.current_user.id
              true
            else
              false
            end
         else
          true
         end
        when :private_then_public
          comment = Replies.find(:last, :conditions => {:discussion_id => discussion, :user_id => self.current_user.id})
          if comment
            true
          else
            false
          end
      end
    else
      false
    end
  end

  def show_comment_lite(comment)
    #not currently being used
    out = "<div class='clientSubComment' id='commentSub#{comment.id}'><a name='##{comment.id}'></a>"
    out = out + "<div class='subCommentAvatar'>"
    out = out + render_avatar(comment.user)
    out = out + "</div>"

    out = out + "<div class='clientSubCommentText' >"
		out = out + "<p>"

		out = out + "<strong>"
    out = out + comment.user.name
    out = out + "</strong> "
		out = out + comment.comment
		if comment.photo_content_type
      if comment.photo_content_type =~ /image.*/
        #out = out + "<a href='#{comment.photo.url}' class='MagicThumb' rel='buttons:hide' target='_blank' >"
        out = out + "<a href='#{comment.photo.url}' target='_blank' >"
        out = out + image_tag(comment.photo.url(:thumb), :style => 'margin-left:1px;')
        out = out + "<span>&nbsp;</span>"
        out = out + "</a>"
      else
        out = out + "<p><a href='#{comment.photo.url}' target='_blank'>View attached file here.</a>"
        out = out + image_tag("download.png")
        out = out + "</p>"
      end
		end
		out = out + "<br/>"

		out = out + "<span>- Posted "
    out = out + time_ago_in_words(comment.created_at)
    out = out + " ago </span>"
		

		out = out + "<div id='subCommentForm#{comment.id}'></div>"
		out = out + "<div id='reclaimer#{comment.id}'></div>"
		@replies = Replies.find(:all, :conditions => { :comment_id => comment.id}, :order => "id DESC", :include => :user)
		for replies in @replies
      displayflag = true
      if cookies[:filter] == "yes"
        displayflag = false
        cookies.to_hash.each_pair do |k, v|
          if cookies[k.to_sym].split('_')[0] == "field"
            #puts cookies[k.to_sym]
            #puts k
            if replies.user.send(cookies[k.to_sym]) == k
              displayflag = true
            end
          end
        end
      end

      if displayflag
        out = out + render_reply(replies)
      end
		end
		out = out + "<div id='#{dom_id(comment)}'>"
		out = out + "</div>"
		out = out + "</div>"
		out = out + "<hr noshade='noshade'/>"
    out = out + "</div>"
    return out
  end

end
