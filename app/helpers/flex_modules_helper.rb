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
end
