module ModuleImagesHelper
  def return_partial_name(flex_module)
    flex_module.module_type.name.downcase.gsub(' ', '_')
  end

  def method_name(number)
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
