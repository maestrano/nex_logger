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

      # lograge is not enabled by default in development
      config.lograge.enabled = ENV['LOGRAGE_ENABLED'].present? || !Rails.env.development?
      config.lograge.custom_options = lambda do |event|
        exceptions = %w(controller action format id)
        {
          params: event.payload[:params].except(*exceptions)
        }
      end

      # The colorization of logging is not active in production
      config.colorize_logging = Rails.env.development?
    end
  end
end
