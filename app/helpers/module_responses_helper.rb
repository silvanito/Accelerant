module ModuleResponsesHelper
  def modules_response_screenshot(module_response)

   unless module_response.module_response_image.nil?
      module_response.module_response_image.create_tmp_image
   else
      ""
   end
  end
end
