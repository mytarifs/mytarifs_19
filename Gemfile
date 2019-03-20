source 'http://rubygems.org'
ruby "2.3.8" 
# previous for production sit was "2.2.4"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
#TODO обновить до 4.1.0
gem 'rails', "4.2.2"

gem 'pg'
gem 'httparty'
gem 'nokogiri'
gem 'poltergeist'
gem 'selenium-webdriver'
gem 'phantomjs.rb', '>= 2.0.0'
gem "capybara"
#gem 'mechanize'
#gem 'roo', '1.13.2'
gem 'roo', '~> 2.1.0'
gem 'roo-xls'
gem 'pdf-reader'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
#  gem 'sass-rails',   '~> 4.0.1'
  gem 'coffee-rails', '~> 4.0.0'
#  gem 'bootstrap-sass', '~> 3.3.1' 
end

  gem 'bootstrap-sass', '~> 3.3.6'
  gem 'sass-rails', '>= 5.0.3'
  gem 'autoprefixer-rails'
  gem 'uglifier', '>= 1.3.0'

gem 'formtastic'
gem 'will_paginate'
gem 'bootstrap-will_paginate'
gem 'bootstrap-datepicker-rails'
gem 'bootswatch-rails'
gem "font-awesome-rails"

gem 'jquery-rails'
gem 'jquery-ui-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks',  '~> 5.0.0' #github: 'rails/turbolinks'


#gem 'jquery-turbolinks'

gem 'remotipart', '~> 1.2' #for ajax file upload
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', '~> 0.4.0', require: false
end

# To use ActiveModel has_secure_password
gem 'bcrypt-ruby' , '~> 3.1.2'

# Use unicorn as the app server
# gem 'unicorn'

#group :test, :development do
#  gem "thin"
#end

# Deploy with Capistrano
# gem 'capistrano', group: :development

# To use debugger
group :development do
  gem 'puma'
#  gem 'thin'
#  gem 'debugger'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'annotate'
#  gem 'localtunnel'
  gem 'spring'  
end

gem 'derailed'  #for Benchmarking rails apps
gem 'stackprof' #profiling methods
gem 'rack-mini-profiler', require: false
gem 'flamegraph'
gem 'memory_profiler'


group :test do
#  gem 'puma'
  gem 'minitest-spec-rails'
  gem 'database_cleaner'
#  gem 'connection_pool'
#  gem 'minitest-rails-capybara'
#  gem 'capybara_minitest_spec'
#  gem "capybara-webkit"  
#  gem 'selenium-webdriver'
#  gem 'minitest-colorize'
#  gem 'minitest-focus'
end

group :production do
  gem 'rails_12factor'
  gem 'rack-timeout'
  gem 'unicorn'
end

gem 'spawnling', '~>2.1' #background processing
#gem 'spawnling', :git => 'git://github.com/tra/spawnling'


gem 'devise'
gem 'omniauth-facebook'
#gem 'omniauth-vk'
gem 'omniauth-vkontakte'
gem 'active_type'

gem 'delayed_job_active_record'
gem "daemons" 
#group :development do
  gem 'sidekiq'
  gem 'sinatra', :require => nil

  gem 'readthis'
  gem 'hiredis'  
  gem 'redis'  
  gem 'redis-rails'
#  gem 'resque'
#end
 
group :development, :test do
 gem 'foreman'
# gem 'web-console', '~> 2.0'
# gem 'dotenv-rails'
end 

 gem 'rush'

gem 'ahoy_matey' #to track visits and events

gem 'aspector' # allows to use aspect oriented programming with Ruby

gem 'rack-cache'
gem 'dalli'
gem 'kgio'
gem "memcachier"
gem 'connection_pool'



gem 'bulk_insert' #array of hashes to sql

gem 'meta-tags'
gem 'friendly_id', '~> 5.1.0' #for pretty ids
gem 'babosa' #transliterate Russian Cyrillic slugs to ASCII

gem "breadcrumbs_on_rails"

gem 'sitemap_generator'

gem 'mailman'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

