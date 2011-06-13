class RepliesController < ApplicationController
  before_filter :login_required
  
  if ENV['RAILS_ENV'] == 'production'
    ssl_required :index, :show, :get, :update, :new, :create, :edit, :add_to_report, :show_image
  end

  def index
    user_id = self.current_user.id
    @replies = Reply.find(:all,:conditions => { :user_id => user_id})
  end
  
  def new
    @reply = Replies.find(:all)
    @reply = Replies.new
  end
  
  def get
    @reply = Replies.new
  end

  def create
    @discussion = Discussion.find(params[:reply][:discussion_id])
    if @discussion.character_minimum.nil?
      charMin = 0
    else
      charMin = @discussion.character_minimum
    end
    #puts params[:reply][:content].length
    #puts (@discussion.character_minimum != 0)
    #puts (params[:reply][:content].length >= @discussion.character_minimum)
    if (charMin == 0) || ((charMin != 0 && params[:reply][:content].length >= charMin))
      @reply = Replies.new(params[:reply])
      @reply.for_report = 0
      @reply.save
      #@comment = Comment.find(@reply.comment_id)
      #@discussion = Discussion.find(params[:reply][:discussion_id])
      #@assignment = Comment.find(:last, :conditions => {:id => params[:reply][:comment_id]})
      #redirect_to "/discussion/show/#{@discussion.id}?project_id=#{@discussion.project_id}#bottom"
      
      next_comment = params[:comment_number].to_i 
      responds_to_parent do
        render :update do |page|
          #page << "document.getElementById('stuff').innerHTML = '';"
          #gunk = render_reply_standalone(@reply)
          @gunk = @reply.content
          #@gunk = @reply.content.gsub(/<\/?[^>]*>/,  "")
          @gunk = @gunk.gsub(/"/,  " ")
          @gunk = @gunk.gsub(/'/,  " ")
          @gunk = @gunk.dump
          #@gunk = @gunk.gsub("/r",  " ")
          #@gunk = @gunk.gsub("/n",  " ")
          #@gunk = simple_format(@gunk)
          #page << "document.getElementById('subCommentForm#{params[:reply][:comment_id]}').innerHTML = '#{@reply.content}';"
          #page << "document.getElementById('subCommentForm#{params[:reply][:comment_id]}').innerHTML = 'Comment posted... Thank you!';"
          unless client_browser_name == "Internet Explorer"
            page << "document.getElementById('notice').style.display='none'"
            page << "document.getElementById('container').style.filter='alpha(opacity = 100)'"
            page << "document.getElementById('container').style.opacity='1'"
          end
          page << "document.getElementById('subCommentForm#{params[:reply][:comment_id]}').innerHTML = 'You just said #{@gunk}';"
          page << "new Effect.ScrollTo($('commentSub#{next_comment}'));" if next_comment == 0

          #page << "document.getElementById('subCommentForm#{@reply.comment_id}').innerHTML = '#{gunk}"
          puts @gunk
        end
      end
      
    else
      #render :text => "Response is too short.  Must be #{@discussion.character_minimum} characters minimum."
      responds_to_parent do
        render :update do |page|
          unless client_browser_name == "Internet Explorer"
            page << "document.getElementById('notice').style.display='none';"
            page << "document.getElementById('container').style.filter='alpha(opacity = 100)';"
            page << "document.getElementById('container').style.opacity='1';"
          end
          page << "document.getElementById('subCommentForm#{params[:reply][:comment_id]}').innerHTML = 'Response is too short.  Must be #{charMin} characters minimum.'"
        end
      end
    end
  end

  def by_user
    @these_replies = Replies.find(:all, :conditions => { :user_id => params[:id]})
  end

  def edit
    @reply = Replies.find(params[:id])
    puts "reply content:"
    puts @reply.content
  end

  def add_to_report
    @subcomment=  Replies.find(params[:id])
    @report_comments = ReportComment.find(:all, :conditions => {:subcomment_id => @subcomment.id})
    @owner = self.current_user.id
    if @report_comments.empty? 
      @report_comment = "new"
    else
      @report_comment = "index"
    end

    if @subcomment.for_report == 1
      @subcomment.for_report = 0
      @subcomment.save

    else
      @subcomment.for_report = 1
      @subcomment.save

    end
    respond_to do |format|
      format.js 
    end


  end

  def update
    @reply = Replies.find(params[:id])
    @reply.content = params[:content]
    @reply.save
    render :text => "updated"
  end

  def show_image
    @reply = Reply.find(params[:id])
    @image = @reply.photo.url(:large)
    render :action => "show_image", :layout => "images"
  end

end
