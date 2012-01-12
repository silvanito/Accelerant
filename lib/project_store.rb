module ProjectStore
  protected
    # Accesses the current project from the session.
    # Future calls avoid the database because nil is not equal to false.
    def current_project
      @current_project ||= session[:project_id] unless @current_project== false
    end

    # Store the given user id in the session.
    def current_project=(new_project)
      session[:project_id] = new_project ? new_project.id : nil
      @current_project = new_project || false
    end

    # Inclusion hook to make #current_project 
    # available as ActionView helper methods.
    def self.included(base)
      base.send  :helper_method, :current_project if base.respond_to? :helper_method
    end
end
