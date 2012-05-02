class MyassignmentsController < ApplicationController
  before_filter :login_required
  

  def show
    @your_assignments_result = UserAssignments.find(:all, :conditions => { :user_id => self.current_user.id})
    @your_assignments_group = @your_assignments_result.group_by{|word| word.project_id}
    @your_assignments = []
    @your_assignments_group.each{|f| @your_assignments << f.last.first }
    @last_ass = UserAssignments.find(:last, :conditions => { :user_id => self.current_user.id})
    @ass = Project.find(@last_ass.project_id)
    @theme = Theme.find(@ass.theme)
#    if session[:notice_comment]
#      session[:notice] = session[:notice_comment]
#      session[:notice_comment] = nil
#    else
#      session[:notice] = nil
#    end
    unless @theme.nil?
      session[:theme] = @theme.id
    else
      session[:theme] = nil
    end
  end
  
end
