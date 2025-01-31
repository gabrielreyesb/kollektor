if Rails.env.development?
  # Only create debug log in development
  debug_logger = ActiveSupport::Logger.new(Rails.root.join('log', 'debug.log'))
  debug_logger.formatter = Rails.logger.formatter
  
  # New way to broadcast logs in Rails 7.1+
  Rails.logger = ActiveSupport::BroadcastLogger.new(Rails.logger, debug_logger)
end 