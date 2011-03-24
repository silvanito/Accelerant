class ReportCommentsController < ApplicationController
  if ENV['RAILS_ENV'] == 'production'
    ssl_required :index, :new, :create, :edit, :update, :destroy
  end
  def index
    @report_comments = ReportComment.all
  end

  def new
    @report_comment = ReportComment.new
    @comment_id = params[:comment_id]
    @owner = self.current_user.id
    respond_to do |format|
      format.js 
    end
  end

  def create
    
    if params[:report_comment]
      @comment_id =  params[:report_comment][:comment_id]
      report_comment = ReportComment.new(params[:report_comment])
    else
      @comment_id =  params[:new][:comment_id]
      report_comment = ReportComment.new(params[:new])
    end
    @comment = Comment.find(@comment_id)
    if report_comment.save
      @report_comments = ReportComment.find(:all, :conditions=>{:comment_id => @comment_id})
      respond_to do |format|
        format.js 
      end
    else
      respond_to do |format|
        format.js {render :text => "error"}
      end
    end
  end
  
  def edit
    @report_comment = ReportComment.find(params[:report_comment])
  end
  
  def update
    @report_comment = ReportComment.find(params[:id])
    unless @report_comment.update_attributes(params[:report_comment])
      redirect_to edit_admin_report_comment_path #pendiente
    else
      @categories = report_comment.all
      flash[:notice] = "report_comment was changed successfully"
      redirect_to edit_admin_report_comment_path #pendiente
    end
  end
  
  def destroy
    report_comment = ReportComment.find(params[:id])
    @comment_id = report_comment.comment_id
    report_comment.delete
    @comment = Comment.find(@comment_id)
    @report_comments = ReportComment.find(:all, :conditions=>{:comment_id => @comment.id})

    @comment.save
    respond_to do |format|
      format.js
    end
    #flash[:notice] = "report_comment was deleted successfully"
    #redirect_to admin_categories_path #pendiente
  end
end
