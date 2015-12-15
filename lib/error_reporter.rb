class ErrorReporter
  def self.report(e)
    error_id = Airbrake.notify_or_ignore(e, parameters: params, cgi_data: ENV.to_hash, session: session)
    ap e.backtrace.take(10)
    p 'Reported via Airbrake: %s' % error_id
  end
end
