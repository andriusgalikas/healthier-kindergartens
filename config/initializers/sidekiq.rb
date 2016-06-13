if Rails.env.development?
    Sidekiq.configure_server do |config|
      config.redis = { url: 'redis://localhost:6379/12' }
    end

    Sidekiq.configure_client do |config|
      config.redis = { url: 'redis://localhost:6379/12' }
    end
elsif Rails.env.production?
    Sidekiq.configure_server do |config|
      config.redis = { url: 'redis://h:pfh29f5oi5ajqe41krigfniij09@ec2-79-125-14-22.eu-west-1.compute.amazonaws.com:13019' }
    end

    Sidekiq.configure_client do |config|
      config.redis = { url: 'redis://h:pfh29f5oi5ajqe41krigfniij09@ec2-79-125-14-22.eu-west-1.compute.amazonaws.com:13019' }
    end
end