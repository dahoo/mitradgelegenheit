if Rails.env.production?
  Sidekiq.configure_server do |config|
    config.redis = { url: "unix://#{Dir.home}/.redis/sock" }
  end

  Sidekiq.configure_client do |config|
    config.redis = { url: "unix://#{Dir.home}/.redis/sock" }
  end
end