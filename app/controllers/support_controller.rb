class SupportController < ApplicationController
  
  def index
    project = Project.find(params[:project_id]) unless params[:project_id].blank?
    unless project.nil?
     @email_support =  project.email_support.nil? ? "info@accelerantresearch.com" : project.email_support
    else
     @email_support = "info@accelerantresearch.com"
    end
  end
end
