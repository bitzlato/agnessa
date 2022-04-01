require_relative "boot"

ENV['RANSACK_FORM_BUILDER'] = '::SimpleForm::FormBuilder'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_mailbox/engine"
require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)
Dotenv::Railtie.load

module Agnessa
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1



    config.generators do |g|
      g.orm :active_record
    end
    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Don't generate system test files.
    config.generators.system_tests = nil

    # Auto-load API and its subdirectories
    # config.paths.add 'app/api', glob: '**/*.rb'
    # config.autoload_paths += Dir["#{Rails.root}/app/api/*"]
    config.i18n.default_locale = :ru
    config.i18n.fallbacks = [:en]
    config.autoloader = :classic
    config.autoload_paths += %W(#{config.root}/lib)

    config.application = config_for(:application)

    config.action_dispatch.tld_length = config.application.default_url_options.fetch(:host).split('.').count-1

    config.autoload_paths += Dir[
      "#{Rails.root}/app/errors",
      "#{Rails.root}/app/services",
      "#{Rails.root}/app/uploaders",
      "#{Rails.root}/app/decorators",
    ]

    config.eager_load_paths << Rails.root.join('lib')
  end
end
