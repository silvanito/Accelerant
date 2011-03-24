class CommentsController < ApplicationController
  before_filter :login_required

  if ENV['RAILS_ENV'] == 'production'
    ssl_required :index, :show, :update, :new, :create, :get, :destroy, :sort, :reorder, :comment_heatmap, :update_report_flag
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
    if params[:comments]
      @discussion = Discussion.find(params[:comments][:discussion_id])
    end
    if @discussion.character_minimum.nil?
      @discussion.character_minimum = 0
      @discussion.save
    end
    if (@discussion.character_minimum == 0 || (@discussion.character_minimum != 0) && (params[:comments][:comment].length >= @discussion.character_minimum))
      @comment = Comment.new(params[:comments])
      @comment.for_report = 0
      @comment.save
      debugger
      session[:comment_id] = @comment.id

       redirect_to "/discussion/show/#{@comment.discussion_id}?project_id=#{@comment.project_id}"


    else
      render :text => "Response is too short.  Must be #{@discussion.character_minimum} characters minimum."
    end
  end

  def comment_heatmap
     if params[:comments]
      @discussion = Discussion.find(params[:comments][:discussion_id])
    end

    if @discussion.character_minimum.nil?
    @discussion.character_minimum = 0
    @discussion.save
    end
    if (@discussion.character_minimum == 0 || (@discussion.character_minimum != 0) && (params[:comments][:comment].length >= @discussion.character_minimum))
      @comment = Comment.new(params[:comments])
      @comment.for_report = 0
      @comment.save
      session[:comment_id] = @comment.id
      session[:notice_comment] = "Preparing your heatmap result. Please wait!."
      session[:comment_heatmap] = "display_none"
      render :action => :comment_heatmap
      #redirect_to :controller => "myassignments", :action => "show"
      #redirect_to :controller => "heatmap", :action => "loading"
      #redirect_to "/discussion/show/#{@comment.discussion_id}?project_id=#{@comment.project_id}"
    else
      render :text => "Response is too short.  Must be #{@discussion.character_minimum} characters minimum."
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
    @report_comment = ReportComment.new
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
    respond_to do |format|
      format.js 
    end
  end 

#  def report_comments
#    @discussion = Discussion.find(params[:id])
#    @project = Project.find(@discussion.project_id)
#    @comments = Comment.find(:all, :conditions => {:discussion_id => params[:id], :for_report => 1 }, :order => "created_at DESC", :include => :user)
#  end

end
