class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  rescue_from NoMethodError, with: :report_exception
  def report_exception(e)
    ap e.backtrace
    @error_id = Airbrake.notify_or_ignore(e, parameters: params, cgi_data: ENV.to_hash, session: session)
    @e = e
    render template: 'public/error'
  end

end
