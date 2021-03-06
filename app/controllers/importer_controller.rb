class ImporterController < ApplicationController



  require 'csv'


  def index

  end

  def csv_import
     # http://satishonrails.wordpress.com/2007/07/18/how-to-import-csv-file-in-rails/
     @parsed_file=CSV::Reader.parse(params[:dump][:file])
     n=0
     @parsed_file.each  do |column|
     if n == 0
      
      @tag = AttributeTags.new
      @tag.field_1 = column[4]
      @tag.field_2 = column[5]
      @tag.field_3 = column[6]
      @tag.field_4 = column[7]
      @tag.field_5 = column[8]
      @tag.field_6 = column[9]
      @tag.field_7 = column[10]
      @tag.field_8 = column[11]
      @tag.field_9 = column[12]
      @tag.field_10 = column[13]
      @tag.project_id = params[:dump][:project_id]
      @tag.save
      n=1
     else
      
      @this_user = User.find_last_by_email(column[2])
      if @this_user.nil?
        
        @user=User.new
        @attribute = Attributes.new
        @user_assignment = UserAssignments.new
      else
        
        @user = User.find_last_by_email(column[2])
        @attribute = Attributes.find_last_by_user_id(@user.id)
        @user_assignment = UserAssignments.find_last_by_user_id(@user.id)
      end
      
      #additional fields
      @user.name = column[0]
      @user.login = column[1]
      @user.email = column[2]
      @user.password = column[3]
      @user.password_confirmation = column[3]
      @user.participant = true
      @user.field_1 = column[4]
      @user.field_2 = column[5]
      @user.field_3 = column[6]
      @user.field_4 = column[7]
      @user.field_5 = column[8]
      @user.field_6 = column[9]
      @user.field_7 = column[10]
      @user.field_8 = column[11]
      @user.field_9 = column[12]
      @user.field_10 = column[13]

      if @attribute.nil?
        @attribute = Attributes.new
      end

      @attribute.field_1 = column[4]
      @attribute.field_2 = column[5]
      @attribute.field_3 = column[6]
      @attribute.field_4 = column[7]
      @attribute.field_5 = column[8]
      @attribute.field_6 = column[9]
      @attribute.field_7 = column[10]
      @attribute.field_8 = column[11]
      @attribute.field_9 = column[12]
      @attribute.field_10 = column[13]
      @attribute.project_id = params[:dump][:project_id]
      #
      if @user.save
        n=n+1
        GC.start if n%50==0
        @attribute.user_id = @user.id
        @attribute.save
        if @user_assignment.nil?
          @user_assignment = UserAssignments.new
        end
        @user_assignment.user_id = @user.id
        @user_assignment.project_id = params[:dump][:project_id]
        @user_assignment.save
      end
     end

     end
     flash.now[:notice]="CSV Import Successful,  #{n-1} new records added/updated."
  end
  
end
