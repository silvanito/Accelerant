class ModuleResponseImagesController < ApplicationController
  before_filter :login_required

  if ENV['RAILS_ENV'] == 'production'
      ssl_required :create
  end

  def create
    @response = ModuleResponseImage.new
    @response.image = params[:image]
    screen_size = params[:screen_data].split(',')
    @response.width = screen_size[0]
    @response.height = screen_size[1]
    if @response.save
      module_image = @response.assign_coords(params[:module_image_coords])
      if module_image == true
        session[:response_image_id] = @response.id
        respond_to do |format|
          format.xml { 
            render :xml => {:result => true, :message => '“Image was saved successfully. Please explain your response by adding a comment in the box below and clicking the Share button.'}
            } 
        end
      else
        respond_to do |format|
          format.xml { 
            render :xml => {:result => false, :message => 'we have a error with module image coords please check'}
            } 
         end
      end
    else
      respond_to do |format|
        format.xml { 
          render :xml => {:result => false, :message => 'we have a error with image  please check'}
          } 
       end
    end
  end


end
