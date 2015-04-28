module NeinDbApiMacros
  def configure_request version=1
    before(:each) do
      request.headers['X-Nein-API-Version'] = version
      request.headers['Accept'] = :json
    end
  end
end
