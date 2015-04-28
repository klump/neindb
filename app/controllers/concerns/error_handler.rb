module ErrorHandler
  def respond_with_error(status: 500, error: "")
    respond_to do |format|
      format.html do
        redirect_to root_url, alert: "Error #{status}: #{error}"
      end
      format.json do
        if error.blank?
          head status: status
        else
          render json: { error: error }, status: status
        end
      end
    end
  end

  def missing_parameter
    respond_with_error(status: 400, error: 'Parameter missing')
  end

  def unauthorized
    respond_with_error(status: 401, error: 'Unauthorized')
  end

  def forbidden 
    respond_with_error(status: 403, error: 'Forbidden')
  end

  def not_found
    respond_with_error(status: 404, error: 'Not found')
  end
end
