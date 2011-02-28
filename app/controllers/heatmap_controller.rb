class HeatmapController < ApplicationController
  before_filter :login_required
  if ENV['RAILS_ENV'] == 'production'
    ssl_required :create
  end

  def create
    if Heatmap.create_heatmap(params[:image_data], params[:encodeData], params[:user_id], params[:discussion_id])
      respond_to do |format|
        format.html { render :nothing => true }
        format.xml { render :xml => 'success'}
      end
    else
      respond_to do |format| 
        format.html { render :nothing => true }
        format.xml { render :xml => 'error' }
      end
    end
  end
end
