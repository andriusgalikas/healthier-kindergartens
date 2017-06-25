require 'sidekiq'
require 'sidekiq-status'

if Rails.env.development?
    Sidekiq.configure_server do |config|
      config.redis = { url: 'redis://localhost:6379/12' }
      config.server_middleware do |chain|
        # accepts :expiration (optional)
        chain.add Sidekiq::Status::ServerMiddleware, expiration: 30.minutes # default
      end
      config.client_middleware do |chain|
        # accepts :expiration (optional)
        chain.add Sidekiq::Status::ClientMiddleware, expiration: 30.minutes # default
      end
    end

    Sidekiq.configure_client do |config|
      config.redis = { url: 'redis://localhost:6379/12' }
      config.client_middleware do |chain|
        # accepts :expiration (optional)
        chain.add Sidekiq::Status::ClientMiddleware, expiration: 30.minutes # default
      end      
    end
elsif Rails.env.production?
    Sidekiq.configure_server do |config|
      config.redis = { url: 'redis://h:pefa6510f42d060e3859cc33475262868237f8a0ef1ab04688e5bac6929f5eeae@ec2-34-252-123-40.eu-west-1.compute.amazonaws.com:28039' }
      config.server_middleware do |chain|
        # accepts :expiration (optional)
        chain.add Sidekiq::Status::ServerMiddleware, expiration: 30.minutes # default
      end
      config.client_middleware do |chain|
        # accepts :expiration (optional)
        chain.add Sidekiq::Status::ClientMiddleware, expiration: 30.minutes # default
      end
    end

    Sidekiq.configure_client do |config|
      config.redis = { url: 'redis://h:pefa6510f42d060e3859cc33475262868237f8a0ef1ab04688e5bac6929f5eeae@ec2-34-252-123-40.eu-west-1.compute.amazonaws.com:28039' }
      config.client_middleware do |chain|
        # accepts :expiration (optional)
        chain.add Sidekiq::Status::ClientMiddleware, expiration: 30.minutes # default
      end      
    end
end