class ApiConstraints
  # Create a new version of the API
  # Parameter: A Hash containing the following keys
  #   :version    Integer     The version of the API
  #   :default    Boolean     Should this version of the API be default?
  def initialize(options)
    @version = options[:version]
    @default = options[:default]
  end

  def matches?(request)
    @default || request.headers['X-Nein-API-Version'].to_s == @version.to_s
  end
end
