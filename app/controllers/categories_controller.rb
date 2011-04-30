class CategoriesController < ApplicationController
  before_filter :login_required
  before_filter :validate_users

  if ENV['RAILS_ENV'] == 'production'
    ssl_required :index, :create, :destroy, :edit, :update, :unassign, :validate_users
  end

  def index
    @categories = Category.all
    @category = Category.new
  end

  def create
    @category = Category.new(params[:category])
    unless @category.save
      @categories = Category.all
      render :action => :index
    else
      redirect_to categories_path
    end
  end

  def destroy
    category = Category.find(params[:id])
    category.delete
    @categories = Category.all
    @category = Category.new
    flash[:notice] = "Category was deleted successfully"
    redirect_to categories_path
  end

  def edit
    @category = Category.find(params[:id])
    @projects = Project.all
  end

  def update
    @category = Category.find(params[:id])
    unless @category.update_attributes(params[:category])
      flash[:notice] = "Category was changed unsuccessfully"
      redirect_to edit_category_path
    else
      unless params[:category][:project_id].blank?
        @category.project_id =  Project.find(params[:category][:project_id]).id
        @category.save
      else
        @category.project_id = nil
        @category.discussions.delete_all
        @category.save
      end

      @categories = Category.all
      flash[:notice] = "Category was changed successfully"
      redirect_to edit_category_path
    end
  end

  def assigned
    @category = Category.find(params[:id])
    @discussions = @category.project.discussions.find(:all, :conditions => {:category_id => nil}) +  @category.project.discussions.find(:all, :conditions => {:category_id => @category.id})
  end

  def assign
    @category = Category.find(params[:id])
    unless params[:discussions].blank?
      discussions = params[:discussions]
      @category.discussions.delete_all
      discussions.each do |discussion|
        @category.discussions << Discussion.find(discussion)
      end
        @category.save
        flash[:notice] = "Discussions was assign successfully"
        redirect_to categories_path
    else
      @category.discussions.delete_all
      flash[:notice] = "Discussions was unassign successfully"
      redirect_to categories_path
    end
  end

  def unassign
    @category = Category.find(params[:id])
    @product_class = ProductClass.find(params[:product_class_id])
    unless @category.product_classes.delete(@product_class)
      redirect_to edit_category_path
    else
      flash[:notice] = "Class was unassigned successfully"
      redirect_to edit_category_path
    end
  end

  private
  def validate_users
    unless self.current_user.admin? || self.current_user.moderator?
      redirect_to project_index_path, :error => "User don't have permissions to access this page"
    end
  end
end
