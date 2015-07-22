module Component::RamModulesHelper
  def display_serials serials
    string = ''
    serials.each do |serial|
      string += "<code>#{serial}</code>\n"
    end
    string.html_safe
  end
end
