require 'lograge'

module NexLogger
  class Configurer
    def self.setup(config)
      if ENV['RAILS_LOG_TO_STDOUT'].present?
        log_level = ([(ENV['LOG_LEVEL'] || ::Rails.application.config.log_level).to_s.upcase, 'INFO'] & %w[DEBUG INFO WARN ERROR FATAL UNKNOWN]).compact.first
        logger = ::ActiveSupport::Logger.new(STDOUT)
        logger.formatter = proc do |severity, datetime, progname, msg|
          "#{datetime} #{severity}: #{String === msg ? msg : msg.inspect}\n"
        end
        logger = ActiveSupport::TaggedLogging.new(logger) if defined?(ActiveSupport::TaggedLogging)
        logger.level = ::ActiveSupport::Logger.const_get(log_level)
        ::Rails.logger = config.logger =logger
        STDOUT.sync = true
      end
      #lograge is not enable by default in development
      config.lograge.enabled = !Rails.env.development?
      #the colorization of logging is not active in production
      config.colorize_logging = Rails.env.development?
    end
  end
end
