class HeatmapController < ApplicationController
  before_filter :login_required
 
 #if ENV['RAILS_ENV'] == 'production'
  #  ssl_required :create
  #end

  def create
    heatmap = Heatmap.create_heatmap(params[:image_data], params[:encodeData], params[:user_id], params[:discussion_id], params[:screen_data])

    if heatmap[:status]
      session[:discussion_id] = params[:disccusion_id] 
#      comment = Comment.find(:last, :conditions => {:discussion_id => heatmap.discussion_id, :user_id => heatmap.user_id})
#      if comment
#        heatmap.comment_id = comment.id
#        heatmap.save
#      end
      respond_to do |format|
        format.html { render :nothing => true }
        format.xml { render :xml => {:result => 'success'} } 
      end
    else

      respond_to do |format| 
        format.html { render :nothing => true }
        format.xml { render :xml => {:result => heatmap[:errors]} }
      end
    end
  end
end
