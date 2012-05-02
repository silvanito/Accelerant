class PlainController < ApplicationController
  layout 'plain'
  uses_yui_editor



  def index
     @latest_postings = Comment.find(:all, :conditions => {:assignment_id => params[:id] }, :limit => 5, :order => "id DESC")
  end
  
  def showlatest
    #this one is the refresher
     @latest_postings = Comment.find(:all, :conditions => {:assignment_id => params[:id] }, :order => "id DESC")
  end
  
  def update_count
    comment_count = Comment.count(:conditions => {:assignment_id => params[:id]} )
  end
  
  def sub_comment_form
    render :partial => "sub_form"
  end

  def sub_form
    render :partial => "sub_form", :layout => "plain", :locals => {:comment => params[:comment]}
  end
  
  def show_comments
    @replies = Replies.find(:all, :conditions => { :comment_id => params[:id]}, :order => "id DESC")
  end
  
  def drop_comment
    @comment = Comment.find(params[:id])
    unless @comment.module_response.nil?
      ModuleResponse.find(@comment.module_response).destroy
    else
      @comment.destroy
    end
    render :text => "Deleted"
  end
  
  def drop_reply
    @reply = Replies.find(params[:id])
    @reply.destroy
    render :text => "Deleted"
  end

  def follow_up
    render :partial => "follow_up_form"
  end

  def follow_up_reply
    render :partial => "follow_up_reply_form"
  end

  def edit_comment
    @comment = Comment.find(params[:id])
  end

  def comment_update
    @comm = Comment.find(params[:comment][:id])
    @comm.update_attribute(:comment, params[:comment][:comment])
    puts @comm.id
    @comm.comment = params[:comment][:comment]
    puts params[:comment][:comment]
    @comm.save
    #out = show_comment(@comment)
    #render :text => @comm.comment
    #render :helper => show_comment(@comment)
    #render :partial => "comments/show/#{@comment.id}"
    #render :update do |page|
    #  page << "window.location.reload(false)"
    #end
    @discussion = Discussion.find(@comm.discussion_id)
    @project = Project.find(@discussion.project_id)
    redirect_to "/discussion/show/#{@discussion.id}?project_id=#{@project.id}"
  end

  def delete_probe
    @probe = FollowUps.find(params[:id])
    @probe.destroy
    render :text => "Deleted"
  end

  

end
