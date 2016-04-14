if Rails.env.development?
    Sidekiq.configure_server do |config|
      config.redis = { url: 'redis://localhost:6379/12' }
    end

    Sidekiq.configure_client do |config|
      config.redis = { url: 'redis://localhost:6379/12' }
    end
elsif Rails.env.production?
    Sidekiq.configure_server do |config|
      config.redis = { url: 'redis://h:pi24k520qhht4cbo5ogisnm5ek@ec2-46-137-82-111.eu-west-1.compute.amazonaws.com:23899' }
    end

    Sidekiq.configure_client do |config|
      config.redis = { url: 'redis://h:pi24k520qhht4cbo5ogisnm5ek@ec2-46-137-82-111.eu-west-1.compute.amazonaws.com:23899' }
    end
end