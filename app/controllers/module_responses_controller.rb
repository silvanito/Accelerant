class ModuleResponsesController < ApplicationController
  before_filter :login_required
  before_filter :get_flex_module

  if ENV['RAILS_ENV'] == 'production'
      ssl_required :new, :create
  end



  def new
    @module_response = ModuleResponse.new
    @module_images = ModuleImage.find(:all, :conditions => {:flex_module_id => @flex_module})
    @comment = Comment.new
  end
  
  def create
    comment = Comment.new(params[:comment])
    @module_response = ModuleResponse.new(params[:module_response])
    if comment.save
      @module_response.comment = comment
      if @module_response.save
        if @module_response.assing_coords(params[:coords])
          respond_to do |format|
            format.html { 
              flash[:notice] = "Response was save sucessfully"
              redirect_to discussion_path(:id => @flex_module.discussion.id, :project_id =>@flex_module.discussion.project.id)
            }
            format.xml { 
              redirect_to discussion_path(:id => @flex_module.discussion.id, :project_id =>@flex_module.discussion.project.id)
             } 
          end
        else
          respond_to do |format|
          format.html{
            flash[:notice] = "Something was wrong with coords data"
            @module_response = ModuleResponse.new
            render :action => :new
          }
          format.xml{ render :xml => {:result => 'Something was wrong with coords data'}}
          end
        end
      else
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

  protected
    def get_flex_module
      @flex_module = FlexModule.find(params[:flex_module_id])
    end
end
