module ReportCommentsHelper
  def user_class(user_id)
    user = User.find(user_id)
    if user.admin || user.moderator
      return "red"
    elsif user.client
      return "green"
    end
  end
end
