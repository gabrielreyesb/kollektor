# This middleware is used to quiet the logs from Active Storage, which can be
# very noisy in development. It silences the logger for any requests that
# are handled by Active Storage's internal controllers.

class QuietAssets
  def initialize(app)
    @app = app
    @paths = [%r{\A/rails/active_storage/}]
  end

  def call(env)
    if @paths.any? { |path| env['PATH_INFO'] =~ path }
      Rails.logger.silence { @app.call(env) }
    else
      @app.call(env)
    end
  end
end

# This inserts the middleware before the default Rails logger, so it can
# intercept and silence the Active Storage logs before they are printed.
Rails.application.middleware.insert_before Rails::Rack::Logger, QuietAssets 