xml.module_images do
  xml.divisions @flex_module.divisions
  xml.participants @participants
  xml.labels do
    (1..@flex_module.divisions).each do |i|
      xml.tag!(method_name(i), @flex_module.method(method_name(i)).call)
    end
  end
end
