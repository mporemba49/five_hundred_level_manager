require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module FiveHundredLevelManager
  class Application < Rails::Application
      config.action_mailer.delivery_method = :smtp
      config.action_mailer.smtp_settings = {
          address: "smtp.gmail.com",
          domain: "gmail.com",
          port:   587,
          user_name: ENV['EMAIL_USER'],
          password: ENV['EMAIL_PASSWORD'],
          authentication: :plain,
          enable_starttls_auto: true
      }
    config.autoload_paths << Rails.root.join('lib')
    config.active_job.queue_adapter = :sidekiq
    config.cache_store = :redis_store, ENV['REDIS_URL'], { expires_in: 90.minutes }
  end
end
