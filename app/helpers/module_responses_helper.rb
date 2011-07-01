module ModuleResponsesHelper
  def modules_response_screenshot(module_response)

   unless module_response.module_response_image.nil?
      module_response.module_response_image.create_tmp_image
   else
      ""
   end
  end

  def module_response_by_comment(comment)
    user = comment.user
    unless user.module_responses.empty?
      unless user.module_responses.last.module_response_image.nil?
        user.module_responses.last.module_response_image.create_tmp_image
      else
        nil
      end
    end
  end
end
