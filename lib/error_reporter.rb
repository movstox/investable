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
    error_id = Airbrake.notify_or_ignore(e, parameters: params, cgi_data: ENV.to_hash, session: session)
    ap e.backtrace.take(10)
    p 'Reported via Airbrake: %s' % error_id
  end
end
