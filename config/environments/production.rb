require "active_support/core_ext/integer/time"

Kollektor::Application.configure do
  config.enable_reloading = false
  config.eager_load = true
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true
  
  # Asset handling
  config.public_file_server.enabled = true
  config.assets.compile = true
  config.assets.digest = true
  
  # Active Storage
  config.active_storage.service = :local
  config.active_storage.replace_on_assign_to_many = false
  
  # Add URL generation host
  config.action_controller.default_url_options = { host: ENV['APP_HOST'] || 'localhost:3000' }
  Rails.application.routes.default_url_options[:host] = ENV['APP_HOST'] || 'localhost:3000'

  config.force_ssl = true
  
  config.logger = ActiveSupport::Logger.new(STDOUT)
    .tap  { |logger| logger.formatter = ::Logger::Formatter.new }
    .then { |logger| ActiveSupport::TaggedLogging.new(logger) }

  config.log_tags = [ :request_id ]
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")
  config.action_mailer.perform_caching = false
  config.i18n.fallbacks = true
  config.active_support.report_deprecations = false
  config.active_record.dump_schema_after_migration = false
end
