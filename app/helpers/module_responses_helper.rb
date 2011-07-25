module ModuleResponsesHelper
  def modules_response_screenshot(module_response)

   unless module_response.module_response_image.nil?
      module_response.module_response_image.create_tmp_image
   else
      ""
   end
  end

  def module_response_by_comment(comment)
    unless comment.module_response.nil?
      comment.module_response.module_response_image.media.url(:medium)
    else
      nil
    end
  end
end
