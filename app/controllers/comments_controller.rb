class CommentsController < ApplicationController
  before_filter :login_required

  if ENV['RAILS_ENV'] == 'production'
    ssl_required :index, :show, :update, :new, :create, :get, :destroy, :sort, :reorder, :comment_heatmap, :update_report_flag, :show_image
  end

  
  def index
    user_id = self.current_user.id
    @comments = Comment.find(:all,:conditions => { :user_id => user_id})
  end
  
  def show
    #user_id = self.current_user.id
    #@comments = Comment.find(:all, :conditions => { :user_id => user_id})
    @comment = Comment.find(params[:id])
  end

  def new
    #@comment = Comment.find(:all)
    @comment = Comment.new
   
  end
  
  def get
    @comment = Comment.new
  end

  def create
    @comment = Comment.new(params[:comment])

    if @comment.save
      session[:comment_id] = @comment.id
      redirect_to "/discussion/show/#{@comment.discussion_id}?project_id=#{@comment.project_id}"
    else
      flash[:notice] = "#{@comment.errors.full_messages}"
      redirect_to "/discussion/show/#{@comment.discussion_id}?project_id=#{@comment.project_id}"
      #render :text => "Response is too short.  Must be #{@comment.discussion.character_minimum} characters minimum."
    end
  end

  def comment_heatmap
    @comment = Comment.new(params[:comment])
    if @comment.save
      session[:comment_id] = @comment.id
      session[:notice_comment] = "Preparing your response.  Please wait."
      session[:comment_heatmap] = "display_none"
      #redirect_to :controller => "myassignments", :action => "show"
      #redirect_to :controller => "heatmap", :action => "loading"
      #redirect_to "/discussion/show/#{@comment.discussion_id}?project_id=#{@comment.project_id}"
    else
      flash[:notice] = "#{@comment.errors.full_messages}"
      redirect_to "/discussion/show/#{@comment.discussion_id}?project_id=#{@comment.project_id}"
    end
  end
  
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    #render :text => "Removed"
  end


  def sort
    @comments = Comment.find(:all, :conditions => {:discussion_id => params[:id] }, :order => :position)
  end

  def reorder
    params[:sortables].each_with_index do |id, index|
      Comment.update_all(['position=?', index+1], ['id=?', id])
      # Update all Sortableitems to position=index+1 where id = id
    end
    render :nothing => true
  end

#filter comments add to report
  def update_report_flag
    @comment = Comment.find(params[:comment_id])
    @report_comments = ReportComment.find(:all, :conditions => {:comment_id => @comment.id})
    @comment_id = @comment.id
    @owner = self.current_user.id
    if @report_comments.empty? 
      @report_comment = "new"
    else
      @report_comment = "index"
    end
    if @comment.for_report == 1
      @comment.for_report = 0
      @comment.save
    else
      @comment.for_report = 1
      @comment.save
    end
    @replies = Replies.find(:all, :conditions=>{:comment_id => @comment.id})
    respond_to do |format|
      format.js 
    end
  end 


  def show_image
    @comment = Comment.find(params[:id])
    @image = @comment.photo.url(:medium)
    render :action => "show_image", :layout => "images"
  end
#  def report_comments
#    @discussion = Discussion.find(params[:id])
#    @project = Project.find(@discussion.project_id)
#    @comments = Comment.find(:all, :conditions => {:discussion_id => params[:id], :for_report => 1 }, :order => "created_at DESC", :include => :user)
#  end

end
