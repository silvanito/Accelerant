module DiscussionHelper
  def modules_show(discussion)
    if self.current_user.admin || self.current_user.moderator
      if discussion.flex_modules.empty?
        return false
      else
        return true
      end
    else
      return false
    end
  end

  def flex_module_display(discussion)
    case discussion.flex_modules.first.module_type.name
      when "Single Image"
        true
      when "Perception map"
        true
      when "Image ranking"
        true
      else
        false
    end
  end
end
