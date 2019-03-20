require File.expand_path('../boot', __FILE__)
require "sprockets/railtie"
require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)
Bundler.require(*Rails.groups(assets: %w(development test)))

module Tarif
  class Application < Rails::Application
    config.middleware.use Rack::Deflater
    config.autoload_paths << "#{Rails.root}/lib"
#    config.eager_load_paths += ["#{config.root}/lib"]
    
#    config.i18n.enforce_available_locales = false
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]
#    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', 'views', 'titles', '**', '*.{rb,yml}')]
    config.i18n.default_locale = :ru
    config.i18n.locale = :ru
    
    config.action_controller.include_all_helpers = false    
    require Rails.root.join("lib/general/custom_public_exceptions")
    config.exceptions_app = General::CustomPublicExceptions.new(Rails.public_path)
#    config.cache_store = :dalli_store
    config.action_dispatch.default_headers = {
      'X-Frame-Options' => '^https?:\/\/([^\/]+\.)?(mytarifs\.ru|www.mytarifs\.ru|webvisor\.com)\/'
    }
    
    config.action_controller.default_url_options = { trailing_slash: true }
  end
end
