class ModuleResponseImagesController < ApplicationController
  before_filter :login_required

  if ENV['RAILS_ENV'] == 'production'
      ssl_required :create
  end

  def create
    @response = ModuleResponseImage.new
    @response.image = params[:image]
    if @response.save
      session[:response_image_id] = @response.id
      respond_to do |format|
        format.xml { 
          render :xml => {:result => true, :message => 'Image was save sucessfully'}
          } 
      end
    else
      respond_to do |format|
        format.xml { 
          render :xml => {:result => false, :result => 'we have a error with data please check'}
          } 
       end
    end
  end


end
