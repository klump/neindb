module RevisionsHelper
 def extract_data data, version
   position = ( version == :old ? 0 : 1 )
   filtered = {}
   data.each do |attr,changes|
     filtered[attr] = changes[position]
   end

   filtered
 end

 def print_old_data data
   "<pre class=\"bg-danger\">#{extract_data(data, :old).to_yaml}</pre>".html_safe
 end

 def print_new_data data
   "<pre class=\"bg-success\">#{extract_data(data, :new).to_yaml}</pre>".html_safe
 end
end
