require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

# Configure Twitter
if Rails.env == 'production'
  TWITTER = { client_id: ENV['client_id'], client_secret: ENV['client_secret'] }
else
  TWITTER = YAML.load(File.read(File.expand_path('../twitter.yml', __FILE__)))
  TWITTER.merge! TWITTER.fetch(Rails.env, {})
  TWITTER.symbolize_keys!
end

# Configure Mandrill
if Rails.env == 'production'
  MANDRILL = { username: ENV['mandrill_username'], password: ENV['mandrill_password'] }
else
  MANDRILL = YAML.load(File.read(File.expand_path('../mandrill.yml', __FILE__)))
  MANDRILL.merge! MANDRILL.fetch(Rails.env, {})
  MANDRILL.symbolize_keys!
end

module Shortener
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true
  end
end
