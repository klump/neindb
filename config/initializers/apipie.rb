Apipie.configure do |config|
  config.app_name                = "NeinDb"
  config.api_base_url            = "/api"
  config.doc_base_url            = "/apipie"
  config.markup	                 = "Apipie::Markup::Textile.new"
  # where is your API defined?
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/api/**/*.rb"
end
