class MypostsController < ApplicationController
  before_filter :login_required
  

  def show
    @mycomments = Comment.find(:all, :conditions => ["user_id = #{self.current_user.id} and comment <> ''"], :order => "id DESC")
  end
end
