module ModuleImagesHelper
  def return_partial_name(flex_module)
    flex_module.module_type.name.downcase.gsub(' ', '_')
  end
end
