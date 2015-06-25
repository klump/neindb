module Component::NicsHelper
  def display_mac_addresses mac_addresses
    string = ''
    mac_addresses.each do |mac|
      string += "<code>#{format_mac mac}</code>\n"
    end
    string.html_safe
  end

  def format_mac mac
    Component::Nic.format_mac mac
  end
end
