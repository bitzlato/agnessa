source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.5'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 6.1.4', '>= 6.1.4.4'
# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'
# Use Puma as the app server
gem 'puma', '~> 5.0'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 5.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
gem 'simple_form-datetimepicker', git: 'https://github.com/bitzlato/simple_form-datetimepicker.git'


gem 'slim-rails'
gem 'ransack', github: 'activerecord-hackery/ransack'
gem 'kaminari'
gem 'draper'
gem 'uglifier'
gem 'execjs'
gem 'mini_racer', '~> 0.4.0'
gem 'bcrypt'
gem 'email_validator'
gem 'invisible_captcha'
gem 'active_link_to'
gem "font-awesome-rails"
gem 'strip_attributes'

# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.4', require: false

gem 'bugsnag'
gem 'jwt', github: 'jwt/ruby-jwt'
gem 'jwt-multisig', '~> 1.0.0'
gem 'jwt-rack', '~> 0.1.0', require: false
gem "sd_notify", "~> 0.1.1"
gem 'dotenv-rails'

group :development, :test do
  gem 'letter_opener'
  gem 'i18n-debug'
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'pry-byebug', '~> 3.7'
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails', '~> 4.0.2'
  gem 'factory_bot'
  gem 'rubocop', require: false
  gem 'webmock'
  gem 'rspec-grape'
  gem 'foreman'

  gem "better_errors"
  gem "binding_of_caller"
end

group :test do
  gem 'faker'
  gem 'timecop'
  gem 'rspec-sidekiq'
  gem 'database_cleaner'
end
gem 'semver2', '~> 3.4'
gem 'semver'

group :deploy do
  gem 'pry-rails'
  gem 'capistrano-dotenv'
  gem 'capistrano-dotenv-tasks'
  gem 'capistrano', require: false
  gem 'capistrano-db-tasks', require: false
  gem 'capistrano3-puma', github: 'seuros/capistrano-puma'
  gem 'capistrano-rbenv', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-shell', require: false
  gem 'capistrano-rails-console', require: false
  gem 'capistrano-systemd-multiservice', github: 'brandymint/capistrano-systemd-multiservice', require: false
  gem 'capistrano-nvm', require: false
  gem 'capistrano-yarn', require: false
  gem 'capistrano-tasks', github: 'brandymint/capistrano-tasks', require: false
  gem 'capistrano-git-with-submodules'
  gem 'bugsnag-capistrano', require: false
  gem 'slackistrano', require: false
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 4.1.0'
  # Display performance information such as SQL time and flame graphs for each request in your browser.
  # Can be configured to work on production as well see: https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  gem 'rack-mini-profiler', '~> 2.0'
  gem 'listen', '~> 3.3'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'sumsub-ruby-sdk', '~> 0.1.3', require: 'sumsub', github: 'bitzlato/sumsub-ruby-sdk'


gem 'mongoid-grid_fs'
gem "grape", "~> 1.6"
gem 'mongoid'
gem 'carrierwave-mongoid'
gem "simple_form", "~> 5.1"
gem "simple_form_extension", "~> 1.4"
gem 'carrierwave', '~> 2.0'
gem 'carrierwave-bombshelter', '~> 0.2.2'
gem 'country_select'
gem 'simple_form_fancy_uploads'
gem 'redactor-rails', github: 'glyph-fr/redactor-rails'
gem 'redis-namespace'
gem 'sidekiq', '~> 6.4.1'
gem 'faraday', '~> 2.0'
gem 'request_store'
gem 'validate_url', '~> 1.0.4'
gem "gravatarify", "~> 3.1"
gem 'sorcery'
gem 'virtus'
gem 'ruby-progressbar'
gem 'env-tweaks'

gem "rails-i18n", "~> 7.0"

gem "carrierwave-video-thumbnailer", "~> 0.1.4"

gem "carrierwave-i18n", "~> 0.2.0"

gem "mini_magick", "~> 4.11"

gem "coffee-rails", "~> 5.0"

gem "nilify_blanks"

gem 'active_record_upsert'

gem "neighbor"

gem "geocoder", "~> 1.8"

gem "bootstrap", "~> 4.3"

gem "browser", "~> 5.3"
