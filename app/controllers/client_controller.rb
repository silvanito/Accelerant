class ClientController < ApplicationController
  before_filter :login_required



  def index
    client_id = self.current_user.id
    @projects = Project.find(:all, :conditions => "client_id = #{self.current_user.id}")

    
  end
end
