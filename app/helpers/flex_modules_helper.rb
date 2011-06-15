module FlexModulesHelper

  def user_response(flex_module)
    self.current_user.module_responses.find(:first, :conditions =>{:flex_module_id => flex_module.id})
  end
  
  def user_response_module_type(flex_module)
    response = self.current_user.module_responses.find(:first, :conditions => {:flex_module_id => flex_module.id})
    unless response.nil?
      if response.flex_module.module_type.name == flex_module.module_type.name
       return true
      end
    else
      return false
    end
  end

  def admin_flex_module_responses_path(flex_module)
    if flex_module.module_images.size > 1
      flex_module_module_responses_path(flex_module)
    else
      flex_module_module_images_path(flex_module)
    end
  end


  def flex_module_new_status(flex_module)
    case flex_module.status.to_sym
    when :drafted
      return "published"
    when :published
      return "drafted"
    end
  end
end
