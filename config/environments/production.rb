require "active_support/core_ext/integer/time"

Kollektor::Application.configure do
  config.enable_reloading = false
  config.eager_load = true
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true
  config.assets.compile = true
  config.active_storage.service = :local
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

  # Enable serving of static files
  config.public_file_server.enabled = true

  # Storage configuration
  config.active_storage.service = :local
  
  # Asset configuration
  config.public_file_server.enabled = true
  config.assets.compile = true
  config.serve_static_assets = true
  config.serve_static_files = true
  
  # Add URL generation host
  Rails.application.routes.default_url_options[:host] = 'kollektor-611834243c86.herokuapp.com'
  config.action_controller.default_url_options = { host: 'kollektor-611834243c86.herokuapp.com' }
end
