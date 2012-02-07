class FlexModulesController < ApplicationController
  before_filter :login_required
  before_filter :get_discussion, :except => :change_status
  before_filter :set_flex_module

  if ENV['RAILS_ENV'] == 'production'
    ssl_required :index, :create, :destroy, :edit, :update
  end

  def index
    @flex_modules = FlexModule.not_deleted.find(:all, :conditions=>{:discussion_id => @discussion.id})
  end

  def new
    @module_types = ModuleType.all
    @flex_module = FlexModule.new
  end

  def create
    @flex_module = FlexModule.new(params[:flex_module])
    unless @flex_module.save
      @flex_module =  FlexModule.not_deleted.find(:all, :conditions=>{:discussion_id => @discussion.id})
      render :action => :index
    else
      redirect_to discussion_path(:id => @discussion, :project_id =>@discussion.project.id)
    end
  end

  def edit
    @flex_module = FlexModule.find(params[:id])
  end

  def update
    @flex_module = FlexModule.find(params[:id])
    @flex_module.update_attributes(params[:flex_module])
    render :action => :edit, :layout => false
  end

  def destroy
    flex_module = FlexModule.find(params[:id])
    flex_module.deleted = 1
    @flex_modules =  FlexModule.not_deleted.find(:all, :conditions=>{:discussion_id => @discussion.id})
    @flex_module = FlexModule.new
    if flex_module.save
      flash[:notice] = "Flex module was deleted successfully"
      redirect_to discussion_path(:id => @discussion, :project_id =>@discussion.project.id)
    else
      flash[:notice] = "Flex module wasnot deleted"
      redirect_to discussion_path(:id => @discussion, :project_id =>@discussion.project.id)
    end
  end

  def change_status
     @flex_module = FlexModule.find(params[:id])
     @flex_module.status = params[:status]
     @flex_module.save
     redirect_to discussion_path(:id => @flex_module.discussion, :project_id =>@flex_module.discussion.project.id)
  end

  protected
    def get_discussion
      @discussion = Discussion.find(params[:discussion_id])
    end
end
