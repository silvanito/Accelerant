module AssignmentHelper

  def size_helper(user)
    if user.participant
      size = [585, 465]
    else
      size = [517, 368]
    end
  end

  def show_heatmap(discussion)
    if discussion.has_heatmap 
      heatmap = Heatmap.find(:last, :conditions => {:discussion_id => discussion.id , :user_id => self.current_user.id})
      unless heatmap && self.current_user.participant
        true
      else
        false
      end
    end
  end

  def heatmap_type(discussion)
    case discussion.heatmap_type.heatmap_type.to_sym
    when :Image
      "HeatMap"
    when :Text
      "HeatMapMarker"
    end
  end

  def heatmap_screenshot(discussion)
   heatmap = discussion.heatmaps.find(:last, :conditions => {:user_id => self.current_user.id})
   if heatmap
      heatmap.create_tmp_image
   else
      ""
   end
  end

  def module_has_comment(discussion)
    if discussion.has_heatmap
       heatmap = self.current_user.heatmaps.find(:last, :conditions => {:discussion_id => discussion.id})
       comment = heatmap.comment unless heatmap.nil?
       if comment
        true
       else
        false
       end
    else
      module_response =  self.current_user.module_responses.find(:last, :conditions => {:flex_module_id => discussion.flex_modules.last.id})
      comment = module_response.comment unless module_response.nil?
      if comment
       true
      else
       false
      end
    end
  end
    #Heatmap.create_tmp_image(discussion.id, self.current_user.id)
end
