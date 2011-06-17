class DiscussionController < ApplicationController
  before_filter :login_required
  if ENV['RAILS_ENV'] == 'production'
    ssl_required :index, :show, :new, :create, :edit, :update, :delete, :discussion_show, :heatmap_admin_result, :show_image
  end



  def new
    @discussion = Discussion.new
    @comment_assignment = CommentAssignments.new
  end

  def delete
    @discussion = Discussion.find(params[:id])
    project = @discussion.project_id
    @discussion.destroy
    redirect_to :controller => 'assignment', :action => 'show', :id => project
  end

  def create
    debugger
    @discussion = Discussion.new(params[:new_discussion])
    #new stuff
    @discussion.has_heatmap = nil if params[:module_type].present?
    @discussion.heatmap_type_id = nil if params[:module_type].present?
    module_type = ModuleType.find(params[:flex_module][:module_type_id])
    @discussion.save
    unless module_type.nil?
      @flex_module = FlexModule.new(params[:flex_module])
      @flex_module.discussion = @discussion
      @flex_module.save
    end
    if self.current_user.admin? || self.current_user.moderator?
    @user_assignments = params[:comment_assignment]
      if @user_assignments
        @these_keys = @user_assignments.keys
        @user_assignments.each do |key, value|
          #if value=="0"
            if value !="0"
              @comment_assignment = CommentAssignments.new
              @comment_assignment.update_attributes(:user_id => key, :discussion_id => @discussion.id)
              @comment_assignment.save
            end
        end
      end
    end
    if @discussion.flex_modules.empty?
      redirect_to :controller => "discussion", :action => "show", :id => @discussion.id, :project_id => @discussion.project_id
    else
      redirect_to :controller => "module_images", :action => "index", :flex_module_id => @flex_module.id
    end
  end

  def show
    self.current_project = Project.find(params[:project_id])
    discussion = Discussion.find(params[:id])
    @module_types = ModuleType.all#discussion.module_types_available
    @flex_module = FlexModule.new
    @flex_modules = FlexModule.not_deleted.find(:all, :conditions=>{:discussion_id => params[:id]})
    @testusers = ""
    @testusers_report = []
    @project_members = []
    @checked_members = []
    @categories = []
    if self.current_user.admin
      @new_discussion = Discussion.new
    end
    if cookies[:filter] == "yes"
      users = []
      assignments = UserAssignments.find(:all, :conditions => {:project_id => params[:project_id]}, :include => :user)
      filter_users = User.find(:all, :conditions => cookies[:sql])
      assignments.each do |participant|
        users << participant.user
      end 
      users.uniq!
      users.each do |user|
        if filter_users.include?(user)
          @checked_members << user 
        else
          @project_members << user
        end
      end
    else
      assignments = UserAssignments.find(:all, :conditions => {:project_id => params[:project_id]}, :include => :user)
      assignments.each do |participant|
        @project_members << participant.user
      end 
      @project_members.uniq!  
    end
    #@project = Project.find(:all, :conditions => {:id => params[:project_id]})
    @project = Project.find(params[ :project_id])
    @discussions = Discussion.find(:all, :conditions => {:project_id => params[:project_id]})
    unless params[:sort] == "by_user"
      @discussion = Discussion.find(params[:id])
    else
      if @discussions && session[:discussion_id].nil?
        @discussion = Discussion.find(params[:id])
      else
         @discussion = Discussion.find(session[:discussion_id])
      end
    end
    unless params[:categorize].blank?
      @categories = @project.categories || []
    end
    
    unless !@discussion || @discussion.sortable.nil?
    @sortable = Sortables.find(@discussion.sortable)
    unless @sortable.nil?
      @usersortables = Usersortables.find_all_by_sortable(@sortable.id, :conditions => {:user => self.current_user.id}, :order => "position ASC" )
      if @usersortables.empty?
        @sortableitems = Sortableitems.find_all_by_sortables(@sortable.id)
        for sortableitem in @sortableitems
          @newusersortable = Usersortables.new
          @newusersortable.user = self.current_user.id
          @newusersortable.sortableitem = sortableitem.id
          @newusersortable.sortable = sortableitem.sortables
          if self.current_user.participant
            @newusersortable.participant = true
          else
            @newusersortable.participant = false
          end
          @newusersortable.save
          @usersortables = Usersortables.find_all_by_sortable(@sortable.id, :conditions => {:user => self.current_user.id}, :order => "position ASC" )
        end
        puts "didnt find none"
      else
        for usersorts in @usersortables
          if self.current_user.participant
            puts "woopee"
            usersorts.participant = true
            usersorts.save
          end
          puts "found some"
        end
      end
    end
    end

    unless !@discussion || @discussion.groupable.nil?
    puts "and we are IN"
    @groupable = Groupables.find(@discussion.groupable)
    @groupabletargets = Groupabletargets.find_all_by_groupable(@groupable.id, :order => "id DESC")
    unless @groupable.nil?
      @usergroupables = Usergroupables.find_all_by_groupable(@groupable.id, :conditions => {:user => self.current_user.id} )
      if @usergroupables.empty?
        @groupableitems = Groupableitems.find_all_by_groupables(@groupable.id)
        for groupableitem in @groupableitems
          @newusergroupable = Usergroupables.new
          @newusergroupable.user = self.current_user.id
          @newusergroupable.groupableitem = groupableitem.id
          @newusergroupable.groupable = groupableitem.groupables
          if self.current_user.participant
            @newusergroupable.participant = true
          else
            @newusergroupable.participant = false
          end
          @newusergroupable.save
          @usergroupables = Usergroupables.find_all_by_groupable(@groupable.id, :conditions => {:user => self.current_user.id})
        end
        puts "did not find groupable"
      else
        for usergroups in @usergroupables
          if self.current_user.participant
            puts "woopee"
            usergroups.participant = true
            usergroups.save
          end
          puts "found some"
        end
      end
    end
    end
    @action = "create"
    if @discussion.has_heatmap && self.current_user.participant
      heatmap = Heatmap.find(:last, :conditions => {:discussion_id => @discussion.id , :user_id => self.current_user.id})
      if heatmap.nil? #no contestado
        @action = "comment_heatmap"
      end
      if heatmap && heatmap.comment_id.nil?
        comment = Comment.find(:last, :conditions => {:discussion_id => @discussion.id , :user_id => self.current_user.id})
        if comment
          heatmap.comment_id = session[:comment_id] || comment.id
          heatmap.save
        end
      end
    end
    session[:discussion_id] = params[:id].blank? ? @discussion.id : params[:id]
    heatmaps = Heatmap.find(:all, :conditions => {:discussion_id => @discussion.id}) 
    users_heatmap = []
    heatmaps.each do |heatmap|
      users_heatmap << heatmap.user_id
    end
    users_heatmap.uniq!
    users_assigned = []
    @discussion_members = CommentAssignments.find(:all, :conditions => {:discussion_id=> @discussion.id})
    @discussion_members.each do |user_assigned|
      users_assigned << user_assigned.user_id
    end 
    answers = users_heatmap & users_assigned
    session[:answers] = answers
    session[:users_assigned] = users_assigned
    discussion = {:user_name => self.current_user.name, :user_id => self.current_user.id, :admin => self.current_user.admin, :image_path => @discussion.media.url, :discussion_id => @discussion.id, :discussion_users => users_assigned.size, :answers => answers.size}
    respond_to do |format|
     format.html
     format.xml { render :xml => discussion.to_xml(:dasherize => false), :layout => false}
    end

  end

  def edit
    
    @discussion = Discussion.find(params[:id])
    @project_members = UserAssignments.find(:all, :conditions => {:project_id => @discussion.project_id}, :include => :user)
  end

  def update
     @discussion = Discussion.find(params[:id])
     @discussion.update_attributes(params[:discussion])
         #new stuff
      if self.current_user.admin? || self.current_user.moderator?
      @user_assignments = params[:comment_assignment]
      if @user_assignments
        @discussion.comment_assignmentss.delete_all
        @user_assignments.each do |key, value|
          if value !="0"
            @comment_assignment = CommentAssignments.create(:user_id => key, :discussion_id => @discussion.id)
          end
        end
#        @these_keys = @user_assignments.keys
#        @user_assignments.each do |key, value|
#          #if value=="0"
#            if value !="0"
#            @comment_assignment = CommentAssignments.new
#            @comment_assignment.update_attributes(:user_id => key, :discussion_id => @discussion.id)
#            @comment_assignment.save
#          end
#      end
      end
    end
    redirect_to :controller => 'discussion', :action => 'show', :id => @discussion.id, :project_id => @discussion.project_id
  end

  def discussion_show
    discussion =  Discussion.find(session[:discussion_id])
    size = Hash.new
    xml_data =  Discussion.create_xml(self.current_user, discussion, session[:user_filters], session[:users_assigned], session[:answers])
    respond_to do |format|
     format.xml { render :xml => xml_data.to_xml(:dasherize => false)}
    end
  end

  def heatmap_admin_result
    unless params[:image].blank? && params[:discussion_id]
      heatmap_admin_result = Discussion.admin_tmp_image(params[:image], params[:discussion_id], self.current_user.id)
    else
      heatmap_admin_result = "something was wrong"
    end
    if heatmap_admin_result
      respond_to do |format|
        format.html { render :nothing => true }
        format.xml { render :xml => {:path => heatmap_admin_result} }
      end
    else
      respond_to do |format|
        format.html { render :nothing => true }
        format.xml { render :xml => {:path => heatmap_admin_result} } 
      end
    end
  end
  
  def show_image
    @discussion = Discussion.find(params[:id])
    @image = @discussion.media.url
    render :action => "show_image", :layout => "images"
  end
end
