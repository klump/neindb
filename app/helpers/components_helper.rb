module ComponentsHelper
  def display_capabilities capabilities
    string = ''
    capabilities.each do |capability|
      string += "<span class=\"label label-default\">#{capability}</span>\n"
    end
    string.html_safe
  end
end
