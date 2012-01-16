class ModuleTypesController < ApplicationController
  before_filter :login_required


#  if ENV['RAILS_ENV'] == 'production'
 #   ssl_required :index, :create, :destroy, :edit, :update
#  end

  def index
    @module_types = ModuleType.all
    @module_type = ModuleType.new
  end

  def create
    @module_type = ModuleType.new(params[:module_type])
    unless @module_type.save
      @module_type = ModuleType.all
      render :action => :index
    else
      redirect_to module_types_path
    end
  end

  def destroy
    module_type = ModuleType.find(params[:id])
    unless module_type.flex_modules.empty?
      flash[:notice] = "This module type is assigned to modules and comments please check this."
      redirect_to module_types_path
    end
    module_type.delete
    @module_types = ModuleType.all
    @module_type = ModuleType.new
    flash[:notice] = "Module type was deleted successfully"
    redirect_to module_types_path
  end

  def edit
    @module_type = ModuleType.find(params[:id])
  end

  def update
    @module_type = ModuleType.find(params[:id])
    unless @module_type.update_attributes(params[:module_type])
      flash[:notice] = "Module type was changed unsuccessfully"
      redirect_to edit_module_type_path
    else
      @module_types = ModuleType.all
      flash[:notice] = "Module type was changed successfully"
      redirect_to module_types_path
    end
  end

end
