LinkedIn.configure do |config|
  config.token = ENV['LNKD_CONSUMER_KEY']
  config.secret = ENV['LNKD_CONSUMER_SECRET']
end