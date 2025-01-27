logfile = File.open(Rails.root.join('log', 'debug.log'), 'a')
logfile.sync = true
DEBUG_LOGGER = Logger.new(logfile)
DEBUG_LOGGER.formatter = proc do |severity, datetime, progname, msg|
  "#{datetime}: #{severity} -- #{msg}\n"
end 