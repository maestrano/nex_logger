require 'nex_logger/configurer'

module NexLogger
  class Railtie < ::Rails::Railtie
    initializer(:nex_logger, before: :initialize_logger) do
      Configurer.setup(config)
    end
  end
end
