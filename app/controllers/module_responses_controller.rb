class ModuleResponsesController < ApplicationController

  before_filter :login_required
  before_filter :get_flex_module, :except => :get_module
  before_filter :set_flex_module, :except => :get_module
  before_filter :get_module_response_image, :only => :create
  before_filter :validate_users, :only => :index

  def index
    @responses = ModuleResponse.find(:all, :conditions=>{:flex_module_id =>  @flex_module.id})
  end

  def new
    @module_response = ModuleResponse.new
    @module_images = ModuleImage.find(:all, :conditions => {:flex_module_id => @flex_module})
    @comment = Comment.new
  end
  
  def create
    comment = Comment.new(params[:comment])
    @module_response = ModuleResponse.new
    if comment.save 
      @module_response.comment = comment
      @module_response.module_response_image = @module_response_image
      @module_response.flex_module_id = @flex_module.id
      @module_response.user_id = self.current_user.id
      if @module_response.save
          session[:response_image_id] = nil
          respond_to do |format|
            format.html { 
              flash[:notice] = "Response was save sucessfully"
              redirect_to discussion_path(:id => @flex_module.discussion.id, :project_id =>@flex_module.discussion.project.id)
            }
            format.xml { 
              render :xml => {:result => 'Response was save sucessfully'}
             } 
          end
      else
        @module_response_image.destroy
        respond_to do |format|
          format.html{
            flash[:notice] = "Something was wrong with response data"
            @module_response = ModuleResponse.new
            render :action => :new
          }
          format.xml{ render :xml => {:result => 'Something was wrong with coords data'}}
        end
      end 
    else
      @module_response_image.destroy
      respond_to do |format|
          format.html{
            flash[:notice] = "Something was wrong with comment data"
            @module_response = ModuleResponse.new
            render :action => :new
          }
      format.xml{ render :xml => {:result => 'Something was wrong with comment data'}}
      end
    end
  end
  
  def show
    @module_response = ModuleResponse.find(params[:id])
  end

  def get_module
    
    respond_to do |format|
      module_info = FlexModule.find(session[:flex_module_id])
      flex_module= {:module_id => module_info.id, :module_type => module_info.module_type.name, :is_admin => self.current_user.admin || self.current_user.client , :is_moderator =>  self.current_user.moderator, :discussion_id => module_info.discussion.id}
      format.xml{ render :xml => flex_module.to_xml(:dasherize => false)}
    end
  end

  protected
    def get_flex_module
      @flex_module = FlexModule.find(params[:flex_module_id])
    end
    def get_module_response_image
      @module_response_image = ModuleResponseImage.find(session[:response_image_id])
    end

    def validate_users
      unless self.current_user.admin? || self.current_user.moderator?
        redirect_to project_index_path, :error => "User don't have permissions to access this page"
      end
    end
end
