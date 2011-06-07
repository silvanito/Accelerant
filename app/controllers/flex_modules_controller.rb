class FlexModulesController < ApplicationController
  before_filter :login_required
  before_filter :get_discussion
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
    unless @flex_module.update_attributes(params[:module_type])
      flash[:notice] = "Flex module type was changed unsuccessfully"
      redirect_to edit_discussion_flex_module_path(@discussion)
    else
      @flex_modules =  @flex_modules = FlexModule.not_deleted.find(:all, :conditions=>{:discussion_id => @discussion.id})
      flash[:notice] = "Flex module type was changed successfully"
      redirect_to discussion_flex_modules_path(@discussion)
    end
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
  protected
    def get_discussion
      @discussion = Discussion.find(params[:discussion_id])
    end
end
