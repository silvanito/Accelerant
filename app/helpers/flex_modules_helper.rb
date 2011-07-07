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

  def user_module_response(flex_module)
    response = self.current_user.module_responses.find(:first, :conditions => {:flex_module_id => flex_module.id})
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
    when :draft
      return "published"
    when :published
      return "draft"
    end
  end

  def print_divisions(number)
    if number%4 == 0
      return "division_quantity_separate"
    else
      return ""
    end
  end

  def show_labels(flex_module)
    if flex_module.module_type.has_label
      "show_labels"
    else
      "hide_labels"
    end
  end

  def show_divisions(flex_module)
    case flex_module.module_type.name.downcase
    when "image ranking"
      "show_divisions"
    when "collage"
      "show_divisions"
    else
      "hide_divisions"
    end
  end

  def title_of_divisions(flex_module)
   case flex_module.module_type.name.downcase
    when "image ranking"
      return "Image to rank"
    when "collage"
      return "Number divisions"
    else
      return "hide_divisions"
    end
  end

  def print_number_label(number)
    case number
    when 1
      :top_label
    when 2
      :right_label
    when 3
      :bottom_label
    when 4
      :left_label
    when 5
      :five_label
    when 6
      :six_label
    when 7
      :seven_label
    when 8
      :eight_label
    when 9
      :nine_label
    when 10
      :ten_label
    when 11
      :eleven_label
    when 12
      :twelve_label
    when 13
      :thirteen_label
    when 14
      :fourteen_label
    when 15
      :fifteen_label
    when 16
      :sixteen_label
    when 17
      :seventeen_label
    when 18
      :eighteen_label
    when 19
      :nineteen_label
    when 20
      :twenty_label
    end
  end
end
