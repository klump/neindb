source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.0'
# Use postgre as the database for Active Record
gem 'pg'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Handle permissions for the API (cross domain resource sharing)
gem 'cors'

# Use sidekiq as workers
gem 'sidekiq'

# Use devise for authentication
gem 'devise'

# Documentation of the API
gem 'apipie-rails'
gem 'RedCloth'

group :development, :test do
  # Generate ERD graphs from the database schema
  gem 'rails-erd'

  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

group :test do
  # Testing stuff
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'ffaker'
end

group :production do
  # Use thin as application server
  gem 'thin'
end
