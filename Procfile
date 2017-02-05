web: bundle exec unicorn -p $PORT -c ./config/unicorn.rb
web: npm install
worker: bundle exec sidekiq -e production