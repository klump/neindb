module NeinDbApiMacros
  def configure_api options
    before(:each) do
      @request.headers['X-Nein-API-Version'] = options[:version]
      @request.headers['Accept'] = :json
    end
  end
end
