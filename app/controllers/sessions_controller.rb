# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  #include AuthenticatedSystem

  layout 'login'

  
  # render new.rhtml
  def new
    @theme = Theme.find_by_name(params["id"])
  end

  def create
    #if cookies[:test_cookie] != "1234567890"
      #flash[:notice] = "Cookies must be enabled."
      #redirect_to  "/login" and return
    #end
    logout_keeping_session!
    user = User.authenticate(params[:login], params[:password])
    if user
      # Protects against session fixation attacks, causes request forgery
      # protection if user resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      reset_session
      self.current_user = user
      new_cookie_flag = (params[:remember_me] == "1")
      handle_remember_cookie! new_cookie_flag
      if user.admin?
        redirect_to  "/project"
      end
      if user.moderator?
        @last_ass = Project.find(:last, :conditions => {:moderator_id => self.current_user.id })
        @ass = Project.find(@last_ass.id) unless @last_ass.nil?
        @theme = Theme.find(@ass.theme) unless @ass.nil?

        unless @theme.nil?
          session[:theme] = @theme.id
        else
          session[:theme] = nil
        end
        redirect_to "/moderator"
      end
      if user.client?
        @last_ass = Project.find(:last, :conditions => {:client_id => self.current_user.id})
        @ass = Project.find(@last_ass.id)
        @theme = Theme.find(@ass.theme)

        unless @theme.nil?
          session[:theme] = @theme.id
        else
          session[:theme] = nil
        end
        redirect_to "/client"
      end
      if user.participant?
        redirect_to  "/myassignments/show"
      end
      flash[:notice] = "Logged in successfully"
    else
      note_failed_signin
      @login       = params[:login]
      # @remember_me = params[:remember_me]
      flash[:notice] = "Login failed"
      render :action => 'new'
    end
  end

  def index
    
  end

  def destroy
    if self.current_user.admin? || self.current_user.moderator?
      heatmaps = Heatmap.all
      discussions = Discussion.all
      unless heatmaps.empty?
        heatmaps.each do |heatmap|
          heatmap.delete_tmp_image
        end
      end
      discussions = Discussion.all
      unless discussions.empty?
        discussions.each do |discussion|
          discussion.delete_admin_tmp_image
        end
      end
      module_responses = ModuleResponse.all
      module_responses.each do |module_response|
        module_response.module_response_image.delete_tmp_image if module_response.module_response_image
      end
    elsif self.current_user.participant?
      heatmaps = self.current_user.heatmaps.empty? ? [] : self.current_user.heatmaps
      unless heatmaps.empty?
        self.current_user.heatmaps.each do |heatmap|
          heatmap.delete_tmp_image
        end
      end
      module_responses = self.current_user.module_responses.empty? ? [] : self.current_user.module_responses
      module_responses.each do |module_response|
        module_response.module_response_image.delete_tmp_image
      end
    end
    logout_killing_session!
    flash[:notice] = "You have been logged out."
    
    redirect_to  "/login"
  end

  def wrong
    
  end



protected
  # Track failed login attempts
  def note_failed_signin
    flash[:error] = "Couldn't log you in as '#{params[:login]}'"
    logger.warn "Failed login for '#{params[:login]}' from #{request.remote_ip} at #{Time.now.utc}"
  end
end
