class ModuleImagesController < ApplicationController
  before_filter :login_required
  before_filter :get_flex_module
  if ENV['RAILS_ENV'] == 'production'
    ssl_required :index, :create, :destroy, :edit, :update
  end

  def index
    @module_images = ModuleImage.find(:all, :conditions =>{:flex_module_id => @flex_module})
    @module_image = ModuleImage.new
    respond_to do |format|
      format.html
      format.xml
    end
  end

  def create
    @module_image = ModuleImage.new(params[:module_image])
    unless @module_image.save
      @module_images = ModuleImage.find(:all, :conditions =>{:flex_module_id => @flex_module})
      render :action => :index
    else
      redirect_to flex_module_module_images_path
    end
  end

  def destroy
    module_image = ModuleImage.find(params[:id])
    module_image.delete
    @module_images = ModuleImage.find(:all, :conditions =>{:flex_module_id => @flex_module})
    @module_image = ModuleImage.new
    flash[:notice] = "Image was deleted successfully"
    redirect_to flex_module_module_images_path
  end

  protected
    def get_flex_module
      @flex_module = FlexModule.find(params[:flex_module_id])
    end
end
