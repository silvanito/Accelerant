class GroupablesController < ApplicationController

  before_filter :login_required
  require 'csv'
  
#  if ENV['RAILS_ENV'] == 'production'
 #   ssl_required :index, :new, :create, :edit, :update, :show, :destroy, :by_user, :export_to_csv
#  end

  def index
    @groupables = Groupables.find(:all)
  end

  def new
    @groupables = Groupables.new
  end

  def create
    @groupables = Groupables.new(params[:groupables])
    @groupables.save
    redirect_to "/groupableitems/new/#{@groupables.id}"
  end

 def edit
    @groupable = Groupables.find_by_id(params[:id])
  end

  def update
    @groupable = Groupables.find_by_id(params[:groupables][:id])
    @groupable.update_attributes(params[:groupables])
    @groupable.save
    redirect_to "/groupableitems/new/#{@groupable.id}"
  end

  def show
    @groupable = Groupables.find_by_id(params[:id])
    @groupableitems = Groupableitems.find_all_by_groupables(params[:id], :order => "position")

    @groupabletargets = Groupabletargets.find_all_by_groupable(params[:id], :order => "id DESC")
    @X = Groupableaxis.find(:last, :conditions => {:orientation => "X", :groupable => params[:id]})
    @Y = Groupableaxis.find(:last, :conditions => {:orientation => "Y", :groupable => params[:id]})
    #@groupabletargets = Groupabletargets.find_all_by_groupable(params[:id], :order => "id ASC")
  end

  def by_user
    @usergroupings = Usergroupables.find_all_by_groupable(params[:id], :group => :user)
  end

  def export_to_csv
     #groupable = Groupables.find(params[:id] )
     groupableitems = Groupableitems.find_all_by_groupables(params[:id])
     groupabletargets = Groupabletargets.find_all_by_groupable(params[:id])
     report = StringIO.new
        CSV::Writer.generate(report, ',') do |content|
        content << ['',
          groupabletargets[0].description,
          groupabletargets[1].description,
          groupabletargets[2].description,
          groupabletargets[3].description,
          'neutral',
          'unknown'
          ]
          groupableitems.each do |c|
            countarray = Array.new
            groupabletargets.each do |d|
              usergroupable = Usergroupables.count(:conditions => {:position => d.id, :groupableitem => c.id})
              usergroupableneutral = Usergroupables.count(:conditions => {:position => 0, :groupableitem => c.id })
              usergroupabledunno = Usergroupables.count(:conditions => {:position => -1, :groupableitem => c.id })
              countarray << usergroupable
            end
            usergroupableneutral = Usergroupables.count(:conditions => {:position => 0, :groupableitem => c.id })
            usergroupabledunno = Usergroupables.count(:conditions => {:position => -1, :groupableitem => c.id })
            content << [c.description + c.image_file_name.to_s,countarray[0],countarray[1],countarray[2],countarray[3],usergroupableneutral,usergroupabledunno]
          end
        end
       report.rewind
       send_data(report.read,:type=>'text/csv;charset=iso-8859-1;',:filename=>'perception_map_report.csv',
       :disposition =>'attachment', :encoding => 'utf8')
  end

end
