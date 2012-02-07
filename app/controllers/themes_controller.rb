class ThemesController < ApplicationController
  before_filter :login_required
  if ENV['RAILS_ENV'] == 'production'
    ssl_required :index, :new, :create, :edit, :update, :show
  end

  def index
    case self.current_user.rol.to_sym
    when :admin
      @themes = Theme.find(:all)
    when :moderator
      @themes = Theme.find(:all, :conditions=>{:owner => self.current_user.id})
    end
  end

  def new
    @theme = Theme.new
  end

  def create
    @theme = Theme.new(params[:theme])
    @theme.owner = self.current_user.id
    if @theme.save
      redirect_to '/themes'
    else
      flash[:error]  = @theme.errors
      render :action => 'new'
    end
  end

  def edit
    @theme = Theme.find(params[:id])
    respond_to do |format|
      format.html
      format.css
    end
  end

  def update
     @theme = Theme.find(params[:id])
     @theme.update_attributes(params[:theme]) 
     if @theme.save
      redirect_to '/themes'
     else
      flash[:error]  = @theme.errors
      render :action => 'edit'
    end
  end

  def show
    
  end

end
