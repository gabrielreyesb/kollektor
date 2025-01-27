if Rails.env.development?
  # Only create debug log in development
  debug_logger = Logger.new(Rails.root.join('log', 'debug.log'))
  Rails.logger.extend(ActiveSupport::Logger.broadcast(debug_logger))
end 