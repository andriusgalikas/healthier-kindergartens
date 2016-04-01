source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.6'
# Use sqlite3 as the database for Active Record
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end


gem 'devise'
gem 'sitemap_generator'
gem 'unicorn', platforms: :ruby

group :production do
  gem 'unicorn-worker-killer'
  gem 'lograge'
  gem 'pg'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'meta_request'
  gem 'quiet_assets'
  gem 'rack-mini-profiler'
  gem 'capistrano', '~> 2.15'
  gem 'bullet'
  gem 'capistrano-unicorn', require: false, platforms: :ruby
  gem 'thin'
  gem 'colorize'
  gem 'annotate'
  gem 'sqlite3'
end

group :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'capybara'
  gem 'capybara-screenshot'
  gem 'poltergeist'
  gem 'database_cleaner'
  gem 'shoulda-matchers'
  gem 'email_spec'
end

group :development, :test do
  gem 'jazz_hands', github: 'nixme/jazz_hands', branch: 'bring-your-own-debugger'
  gem 'pry-byebug'
end

gem 'fast_blank'
gem 'jquery-turbolinks'
gem 'compass-rails'
gem 'rollbar'
gem 'whenever', require: false

gem 'gibbon'

# payment processor
gem 'stripe'
gem 'stripe-rails'

# image processing
gem 'mini_magick'
gem 'carrierwave'

# background processing
gem 'sidekiq'
gem 'sidekiq-failures'
gem 'sinatra', :require => nil

# fake data
gem 'faker'