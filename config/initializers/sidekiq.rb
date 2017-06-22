if Rails.env.development?
    Sidekiq.configure_server do |config|
      config.redis = { url: 'redis://localhost:6379/12' }
    end

    Sidekiq.configure_client do |config|
      config.redis = { url: 'redis://localhost:6379/12' }
    end
elsif Rails.env.production?
    Sidekiq.configure_server do |config|
      config.redis = { url: 'redis://h:pefa6510f42d060e3859cc33475262868237f8a0ef1ab04688e5bac6929f5eeae@ec2-34-252-123-40.eu-west-1.compute.amazonaws.com:28039' }
    end

    Sidekiq.configure_client do |config|
      config.redis = { url: 'redis://h:pefa6510f42d060e3859cc33475262868237f8a0ef1ab04688e5bac6929f5eeae@ec2-34-252-123-40.eu-west-1.compute.amazonaws.com:28039' }
    end
end