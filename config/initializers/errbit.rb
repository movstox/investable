Airbrake.configure do |config|
  config.api_key = ENV['errbit_api_key']
  config.host    = ENV['errbit_host']
  config.port    = 80
  config.secure  = config.port == 443
  config.development_environments = []
end

