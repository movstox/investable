class ErrorReporter
  def self.report(e)
    params = if defined?(params)
      params
    else
      {}
    end
    session = if defined?(session)
      session
    else
      {}
    end
    ap e.message
    ap e.backtrace
    error_id = Airbrake.notify_or_ignore(e, parameters: params, cgi_data: ENV.to_hash, session: session)
    p 'Reported via Airbrake: %s' % error_id
  end
end
