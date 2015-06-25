module Component::CpusHelper
  def display_cpu_extensions extensions
    string = ''
    extensions.split.each do |extension|
      string += "<span class=\"label label-default\">#{extension}</span>\n"
    end
    string.html_safe
  end
end
