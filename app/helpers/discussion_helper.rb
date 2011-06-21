module DiscussionHelper
  def modules_show(discussion)
    if self.current_user.admin || self.current_user.moderator
      if discussion.flex_modules.empty?
        return false
      else
        return true
      end
    else
      if discussion.flex_modules.published.empty?
        return false
      else
        return true
      end
    end
  end
end
