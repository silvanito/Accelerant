class ProjectController < ApplicationController
  before_filter :login_required

  if ENV['RAILS_ENV'] == 'production'
    ssl_required :index, :new, :create, :edit, :update, :drop, :show_image
  end

  def index
    cookies.to_hash.each_pair do |k, v|
      if cookies[k.to_sym].split('_')[0] == "field"
        cookies.delete(k.to_sym)
      end
    end
    cookies.delete(:filter)
    @these_projects = Project.find(:all)
  end
  
  def new
    @this_project = Project.find(:all)
    @this_project = Project.new
  end
  
  def create
    @this_project = Project.new(params[:projects])
    @this_project.save
    unless @this_project.errors.empty?
      render :action => :new
    else
      redirect_to  "/project"
    end
    #render :text => "Project Created!"
  end
  
  def edit
    case self.current_user.rol.to_sym
      when :admin
        @themes = Theme.find(:all)
      when :moderator
        @themes = Theme.find(:all, :conditions=>{:owner => self.current_user.id})
    end
    
    @this_project = Project.find(params[:id])
    @sortables = Sortables.find_all_by_project_id(params[:id])
    @groupables = Groupables.find_all_by_project_id(params[:id])
  end
  
  def update
    if params[:this_project][:theme].blank?
      params[:this_project][:theme] = 1
    end
    case self.current_user.rol.to_sym
      when :admin
        @themes = Theme.find(:all)
      when :moderator
        @themes = Theme.find(:all, :conditions=>{:owner => self.current_user.id})
    end
    @sortables = Sortables.find_all_by_project_id(params[:id])
    @groupables = Groupables.find_all_by_project_id(params[:id])
    @this_project = Project.find(params[:id])
    @this_project.update_attributes(params[:project])
    @this_project.update_attributes(params[:this_project])
    unless @this_project.errors.empty?
      render :action => :edit
    else
      if self.current_user.admin
        redirect_to "/project"
      end
      if self.current_user.moderator
        redirect_to "/moderator"
      end
    end
  end
  
  def drop
    @this_project = Project.find(params[:id])
    @this_project.destroy
    if self.current_user.admin
      redirect_to "/project"
    end
    if self.current_user.moderator
      redirect_to "/moderator"
    end
  end

  def show_image
    @project = Project.find(params[:id])
    @image = @project.photo.url(:large)
    render :action => "show_image", :layout => "images"
  end
end
